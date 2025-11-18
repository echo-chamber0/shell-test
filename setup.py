#!/usr/bin/env python3
"""
Data Commons Cloud Run Deployment Configuration

Interactive configuration tool for GCP Cloud Run deployment.
Validates inputs and generates Terraform variable files.
"""

import os
import re
import subprocess
import sys
from pathlib import Path

try:
    import questionary
    from questionary import ValidationError, Validator
    from rich.console import Console
    from rich.panel import Panel
    from rich.progress import Progress, SpinnerColumn, TextColumn
    from rich.table import Table
except ImportError:
    print("Installing required dependencies...")
    subprocess.check_call([
        sys.executable, "-m", "pip", "install", 
        "-q", "-r", "requirements.txt"
    ])
    import questionary
    from questionary import ValidationError, Validator
    from rich.console import Console
    from rich.panel import Panel
    from rich.progress import Progress, SpinnerColumn, TextColumn
    from rich.table import Table

console = Console()


class GCPProjectIDValidator(Validator):
    """Validates GCP project ID format."""
    
    def validate(self, document):
        text = document.text
        pattern = r'^[a-z][a-z0-9-]{4,28}[a-z0-9]$'
        
        if not re.match(pattern, text):
            raise ValidationError(
                message="Invalid project ID format. Must be 6-30 characters, "
                        "lowercase letters, numbers, and hyphens only. "
                        "Must start with a letter.",
                cursor_position=len(text)
            )


class ServiceNameValidator(Validator):
    """Validates Cloud Run service name format."""
    
    def validate(self, document):
        text = document.text
        pattern = r'^[a-z0-9][a-z0-9-]{0,61}[a-z0-9]$|^[a-z0-9]$'
        
        if not re.match(pattern, text):
            raise ValidationError(
                message="Invalid service name. Must be 1-63 characters, "
                        "lowercase letters, numbers, and hyphens. "
                        "Must start and end with alphanumeric character.",
                cursor_position=len(text)
            )


def get_available_regions():
    """Return list of available GCP regions for Cloud Run."""
    return [
        "us-central1",
        "us-east1",
        "us-east4",
        "us-west1",
        "europe-west1",
        "europe-west4",
        "asia-east1",
        "asia-northeast1",
        "asia-southeast1",
    ]


def verify_project_access(project_id):
    """Verify user has access to the specified GCP project."""
    try:
        subprocess.run(
            ["gcloud", "projects", "describe", project_id],
            capture_output=True,
            text=True,
            check=True,
            timeout=10
        )
        return True
    except (subprocess.CalledProcessError, subprocess.TimeoutExpired, FileNotFoundError):
        return False


def generate_tfvars(config):
    """Generate terraform.tfvars file from configuration."""
    tfvars_content = f"""# Generated configuration for Data Commons deployment
project_id = "{config['project_id']}"
service_name = "{config['service_name']}"
region = "{config['region']}"
allow_unauthenticated = {str(config['allow_unauthenticated']).lower()}
container_image = "gcr.io/cloudrun/hello"
"""
    
    tfvars_path = Path("terraform/terraform.tfvars")
    tfvars_path.parent.mkdir(exist_ok=True)
    tfvars_path.write_text(tfvars_content)
    
    return tfvars_path


def main():
    """Main configuration workflow."""
    
    console.print()
    console.print(Panel.fit(
        "[bold]Data Commons Deployment Configuration[/bold]\n\n"
        "This tool will configure your Cloud Run deployment.\n"
        "All inputs are validated before proceeding.",
        border_style="blue"
    ))
    console.print()
    
    config = {}
    
    # Project ID
    console.print("[bold]Step 1:[/bold] GCP Project Configuration")
    config['project_id'] = questionary.text(
        "Enter GCP Project ID:",
        validate=GCPProjectIDValidator,
        instruction="Example: my-project-12345"
    ).ask()
    
    if not config['project_id']:
        console.print("Configuration cancelled.")
        sys.exit(0)
    
    # Verify project access
    with Progress(
        SpinnerColumn(),
        TextColumn("[progress.description]{task.description}"),
        console=console,
        transient=True
    ) as progress:
        progress.add_task("Verifying project access...", total=None)
        
        if not verify_project_access(config['project_id']):
            console.print(f"[red]Cannot access project: {config['project_id']}[/red]")
            console.print("Ensure project ID is correct and you have necessary permissions.")
            sys.exit(1)
    
    console.print(f"[green]Project verified: {config['project_id']}[/green]\n")
    
    # Service Name
    console.print("[bold]Step 2:[/bold] Service Configuration")
    config['service_name'] = questionary.text(
        "Enter service name:",
        default="datacommons-service",
        validate=ServiceNameValidator,
        instruction="Lowercase alphanumeric and hyphens only"
    ).ask()
    
    if not config['service_name']:
        console.print("Configuration cancelled.")
        sys.exit(0)
    
    # Region
    console.print()
    config['region'] = questionary.select(
        "Select deployment region:",
        choices=get_available_regions(),
        instruction="Choose region closest to your users"
    ).ask()
    
    if not config['region']:
        console.print("Configuration cancelled.")
        sys.exit(0)
    
    # Access Control
    console.print()
    console.print("[bold]Step 3:[/bold] Access Configuration")
    config['allow_unauthenticated'] = questionary.confirm(
        "Allow public (unauthenticated) access?",
        default=True,
        instruction="If no, only authenticated requests will be allowed"
    ).ask()
    
    if config['allow_unauthenticated'] is None:
        console.print("Configuration cancelled.")
        sys.exit(0)
    
    # Display summary
    console.print()
    console.print(Panel.fit(
        "[bold]Configuration Summary[/bold]",
        border_style="green"
    ))
    
    table = Table(show_header=False, box=None, padding=(0, 2))
    table.add_column("Setting", style="cyan", no_wrap=True)
    table.add_column("Value", style="white")
    
    table.add_row("Project ID", config['project_id'])
    table.add_row("Service Name", config['service_name'])
    table.add_row("Region", config['region'])
    table.add_row(
        "Public Access", 
        "Yes" if config['allow_unauthenticated'] else "No (authenticated only)"
    )
    
    console.print(table)
    console.print()
    
    # Confirm
    proceed = questionary.confirm(
        "Proceed with this configuration?",
        default=True
    ).ask()
    
    if not proceed:
        console.print("Configuration cancelled.")
        sys.exit(0)
    
    # Generate configuration file
    with Progress(
        SpinnerColumn(),
        TextColumn("[progress.description]{task.description}"),
        console=console,
        transient=True
    ) as progress:
        progress.add_task("Generating configuration...", total=None)
        tfvars_path = generate_tfvars(config)
    
    console.print(f"[green]Configuration saved to: {tfvars_path}[/green]")
    console.print()
    console.print(Panel.fit(
        "[bold green]Configuration Complete[/bold green]\n\n"
        "Next steps:\n"
        "  cd terraform\n"
        "  terraform init\n"
        "  terraform apply\n\n"
        "Or follow the tutorial for guided deployment.",
        border_style="green"
    ))
    console.print()


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        console.print("\n\nConfiguration cancelled by user.")
        sys.exit(0)
    except Exception as e:
        console.print(f"\n\n[red]Error: {e}[/red]")
        sys.exit(1)
