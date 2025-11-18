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
    from rich.text import Text
    from rich import box
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
    from rich.text import Text
    from rich import box

console = Console()


def print_welcome_banner():
    """Display professional 3D welcome banner."""
    banner = """
    ██████╗  █████╗ ████████╗ █████╗      ██████╗ ██████╗ ███╗   ███╗███╗   ███╗ ██████╗ ███╗   ██╗███████╗
    ██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗    ██╔════╝██╔═══██╗████╗ ████║████╗ ████║██╔═══██╗████╗  ██║██╔════╝
    ██║  ██║███████║   ██║   ███████║    ██║     ██║   ██║██╔████╔██║██╔████╔██║██║   ██║██╔██╗ ██║███████╗
    ██║  ██║██╔══██║   ██║   ██╔══██║    ██║     ██║   ██║██║╚██╔╝██║██║╚██╔╝██║██║   ██║██║╚██╗██║╚════██║
    ██████╔╝██║  ██║   ██║   ██║  ██║    ╚██████╗╚██████╔╝██║ ╚═╝ ██║██║ ╚═╝ ██║╚██████╔╝██║ ╚████║███████║
    ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝     ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝
    """
    
    subtitle = """
         ██████╗██╗      ██████╗ ██╗   ██╗██████╗     ██████╗ ██╗   ██╗███╗   ██╗
        ██╔════╝██║     ██╔═══██╗██║   ██║██╔══██╗    ██╔══██╗██║   ██║████╗  ██║
        ██║     ██║     ██║   ██║██║   ██║██║  ██║    ██████╔╝██║   ██║██╔██╗ ██║
        ██║     ██║     ██║   ██║██║   ██║██║  ██║    ██╔══██╗██║   ██║██║╚██╗██║
        ╚██████╗███████╗╚██████╔╝╚██████╔╝██████╔╝    ██║  ██║╚██████╔╝██║ ╚████║
         ╚═════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
    """
    
    # Print banner with gradient effect
    console.print(banner, style="bold cyan", highlight=False)
    console.print(subtitle, style="bold blue", highlight=False)
    console.print()
    
    # Subtitle text
    console.print("    " + "═" * 90, style="dim blue")
    console.print("                          INTERACTIVE DEPLOYMENT CONFIGURATION", style="bold white")
    console.print("    " + "═" * 90, style="dim blue")
    console.print()
    
    # Description panel
    description = Text()
    description.append("This tool will guide you through configuring your Cloud Run deployment.\n\n", style="white")
    description.append("What you'll configure:\n", style="bold cyan")
    description.append("  • GCP Project and Region\n", style="white")
    description.append("  • Service Configuration\n", style="white")
    description.append("  • Access Control Settings\n", style="white")
    description.append("\nAll inputs are validated to ensure correct deployment.", style="dim white")
    
    console.print(Panel(
        description,
        border_style="blue",
        box=box.ROUNDED,
        padding=(1, 2)
    ))
    console.print()


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
        "us-central1 (Iowa, USA)",
        "us-east1 (South Carolina, USA)",
        "us-east4 (Virginia, USA)",
        "us-west1 (Oregon, USA)",
        "europe-west1 (Belgium)",
        "europe-west4 (Netherlands)",
        "asia-east1 (Taiwan)",
        "asia-northeast1 (Tokyo, Japan)",
        "asia-southeast1 (Singapore)",
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
# Generated by: setup.py

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


def print_step_header(step_number, title):
    """Print formatted step header."""
    step_text = Text()
    step_text.append(f"\n[Step {step_number}] ", style="bold cyan")
    step_text.append(title, style="bold white")
    console.print(step_text)
    console.print("─" * 60, style="dim blue")


def print_success_message(message):
    """Print success message with checkmark."""
    console.print(f"  ✓ {message}", style="green")


def print_error_message(message):
    """Print error message with X mark."""
    console.print(f"  ✗ {message}", style="red")


def main():
    """Main configuration workflow."""
    
    # Display welcome banner
    print_welcome_banner()
    
    config = {}
    
    # Step 1: Project ID
    print_step_header(1, "GCP Project Configuration")
    console.print()
    
    config['project_id'] = questionary.text(
        "Enter your GCP Project ID:",
        validate=GCPProjectIDValidator,
        style=questionary.Style([
            ('question', 'bold cyan'),
            ('answer', 'bold white'),
        ])
    ).ask()
    
    if not config['project_id']:
        console.print("\n[yellow]Configuration cancelled by user.[/yellow]\n")
        sys.exit(0)
    
    # Verify project access
    console.print()
    with Progress(
        SpinnerColumn(style="cyan"),
        TextColumn("[cyan]{task.description}[/cyan]"),
        console=console,
        transient=True
    ) as progress:
        task = progress.add_task("Verifying project access...", total=None)
        
        if not verify_project_access(config['project_id']):
            console.print()
            print_error_message(f"Cannot access project: {config['project_id']}")
            console.print("\n  [dim]Ensure project ID is correct and you have necessary permissions.[/dim]\n")
            sys.exit(1)
        
        progress.update(task, completed=True)
    
    console.print()
    print_success_message(f"Project verified: {config['project_id']}")
    console.print()
    
    # Step 2: Service Name
    print_step_header(2, "Service Configuration")
    console.print()
    
    config['service_name'] = questionary.text(
        "Enter service name:",
        default="datacommons-service",
        validate=ServiceNameValidator,
        style=questionary.Style([
            ('question', 'bold cyan'),
            ('answer', 'bold white'),
        ])
    ).ask()
    
    if not config['service_name']:
        console.print("\n[yellow]Configuration cancelled by user.[/yellow]\n")
        sys.exit(0)
    
    console.print()
    print_success_message(f"Service name: {config['service_name']}")
    
    # Step 3: Region
    print_step_header(3, "Deployment Region")
    console.print()
    
    region_choice = questionary.select(
        "Select your deployment region:",
        choices=get_available_regions(),
        style=questionary.Style([
            ('question', 'bold cyan'),
            ('highlighted', 'bold white on blue'),
        ])
    ).ask()
    
    if not region_choice:
        console.print("\n[yellow]Configuration cancelled by user.[/yellow]\n")
        sys.exit(0)
    
    # Extract region code from selection
    config['region'] = region_choice.split(' ')[0]
    
    console.print()
    print_success_message(f"Region: {region_choice}")
    
    # Step 4: Access Control
    print_step_header(4, "Access Control")
    console.print()
    
    config['allow_unauthenticated'] = questionary.confirm(
        "Allow public (unauthenticated) access?",
        default=True,
        style=questionary.Style([
            ('question', 'bold cyan'),
            ('answer', 'bold white'),
        ])
    ).ask()
    
    if config['allow_unauthenticated'] is None:
        console.print("\n[yellow]Configuration cancelled by user.[/yellow]\n")
        sys.exit(0)
    
    console.print()
    access_status = "Public access enabled" if config['allow_unauthenticated'] else "Authenticated access only"
    print_success_message(access_status)
    console.print()
    
    # Display configuration summary
    console.print()
    summary_panel = Panel(
        _create_summary_table(config),
        title="[bold white]Configuration Summary[/bold white]",
        border_style="green",
        box=box.DOUBLE,
        padding=(1, 2)
    )
    console.print(summary_panel)
    console.print()
    
    # Confirm configuration
    proceed = questionary.confirm(
        "Proceed with this configuration?",
        default=True,
        auto_enter=False,
        style=questionary.Style([
            ('question', 'bold yellow'),
            ('answer', 'bold white'),
        ])
    ).ask()
    
    if not proceed:
        console.print("\n[yellow]Configuration cancelled by user.[/yellow]\n")
        sys.exit(0)
    
    # Generate configuration file
    console.print()
    with Progress(
        SpinnerColumn(style="cyan"),
        TextColumn("[cyan]{task.description}[/cyan]"),
        console=console,
        transient=True
    ) as progress:
        task = progress.add_task("Generating Terraform configuration...", total=None)
        tfvars_path = generate_tfvars(config)
        progress.update(task, completed=True)
    
    console.print()
    print_success_message(f"Configuration saved: {tfvars_path}")
    console.print()
    
    # Display next steps
    next_steps = Text()
    next_steps.append("\nNext Steps:\n\n", style="bold white")
    next_steps.append("  1. ", style="cyan")
    next_steps.append("Initialize Terraform:  ", style="white")
    next_steps.append("cd terraform && terraform init\n", style="bold yellow")
    next_steps.append("  2. ", style="cyan")
    next_steps.append("Review changes:       ", style="white")
    next_steps.append("terraform plan\n", style="bold yellow")
    next_steps.append("  3. ", style="cyan")
    next_steps.append("Deploy infrastructure: ", style="white")
    next_steps.append("terraform apply\n", style="bold yellow")
    next_steps.append("\n  Or follow the tutorial in the right panel for guided deployment.\n", style="dim white")
    
    console.print(Panel(
        next_steps,
        title="[bold green]Configuration Complete[/bold green]",
        border_style="green",
        box=box.ROUNDED,
        padding=(1, 2)
    ))
    console.print()


def _create_summary_table(config):
    """Create formatted summary table."""
    table = Table(
        show_header=False,
        box=None,
        padding=(0, 2),
        expand=False
    )
    table.add_column("Setting", style="cyan", no_wrap=True, width=20)
    table.add_column("Value", style="white")
    
    table.add_row("Project ID", config['project_id'])
    table.add_row("Service Name", config['service_name'])
    table.add_row("Region", config['region'])
    
    access_text = "Yes (Public)" if config['allow_unauthenticated'] else "No (Authenticated only)"
    table.add_row("Public Access", access_text)
    
    return table


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        console.print("\n\n[yellow]Configuration cancelled by user.[/yellow]\n")
        sys.exit(0)
    except Exception as e:
        console.print(f"\n\n[red]Error: {e}[/red]\n")
        sys.exit(1)
