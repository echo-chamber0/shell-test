#!/usr/bin/env python3
"""
Data Commons Cloud Run Deployment Tool

Fully automated deployment tool - user only selects options,
everything else is handled automatically including Terraform execution.
"""

import os
import re
import subprocess
import sys
import time
from pathlib import Path

try:
    import questionary
    from questionary import ValidationError, Validator
    from rich.console import Console
    from rich.panel import Panel
    from rich.progress import Progress, SpinnerColumn, TextColumn, BarColumn
    from rich.table import Table
    from rich.text import Text
    from rich import box
    from rich.live import Live
    from rich.layout import Layout
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
    from rich.progress import Progress, SpinnerColumn, TextColumn, BarColumn
    from rich.table import Table
    from rich.text import Text
    from rich import box
    from rich.live import Live
    from rich.layout import Layout

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
    
    console.print(banner, style="bold cyan", highlight=False)
    console.print(subtitle, style="bold blue", highlight=False)
    console.print()
    console.print("    " + "═" * 90, style="dim blue")
    console.print("                       AUTOMATED DEPLOYMENT TOOL - NO COMMANDS NEEDED", style="bold white")
    console.print("    " + "═" * 90, style="dim blue")
    console.print()
    
    description = Text()
    description.append("This tool handles everything automatically:\n\n", style="white")
    description.append("  ✓ Configuration collection and validation\n", style="green")
    description.append("  ✓ Terraform initialization and planning\n", style="green")
    description.append("  ✓ Infrastructure deployment\n", style="green")
    description.append("  ✓ Service URL retrieval\n\n", style="green")
    description.append("You only need to answer a few questions. Everything else is automated.", style="dim white")
    
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


def ensure_gcloud_auth(project_id):
    """Ensure gcloud is properly authenticated and project is set."""
    try:
        # Set the active project
        console.print(f"[dim]Setting active project: {project_id}[/dim]")
        subprocess.run(
            ["gcloud", "config", "set", "project", project_id],
            capture_output=True,
            check=True,
            timeout=10
        )
        
        # Print application-default credentials to ensure they're available
        result = subprocess.run(
            ["gcloud", "auth", "application-default", "print-access-token"],
            capture_output=True,
            text=True,
            timeout=10
        )
        
        if result.returncode == 0 and result.stdout.strip():
            console.print("[dim]Authentication verified[/dim]")
            return True
        
        # If token doesn't exist, try to create it
        console.print("[yellow]Setting up application credentials...[/yellow]")
        
        # In Cloud Shell, we can use gcloud auth print-access-token
        # and set it as GOOGLE_OAUTH_ACCESS_TOKEN
        result = subprocess.run(
            ["gcloud", "auth", "print-access-token"],
            capture_output=True,
            text=True,
            timeout=10
        )
        
        if result.returncode == 0 and result.stdout.strip():
            # Set the token as environment variable for Terraform
            os.environ['GOOGLE_OAUTH_ACCESS_TOKEN'] = result.stdout.strip()
            console.print("[dim]Access token configured[/dim]")
            return True
        
        return True
    except Exception as e:
        console.print(f"[dim]Auth setup note: {e}[/dim]")
        return True


def verify_project_access(project_id):
    """Verify user has access to the specified GCP project."""
    try:
        result = subprocess.run(
            ["gcloud", "projects", "describe", project_id],
            capture_output=True,
            text=True,
            check=True,
            timeout=10
        )
        return True
    except Exception:
        return False


def run_command(cmd, cwd=None, description="Running command"):
    """Run a command and return success status."""
    try:
        result = subprocess.run(
            cmd,
            cwd=cwd,
            capture_output=True,
            text=True,
            check=True
        )
        return True, result.stdout
    except subprocess.CalledProcessError as e:
        return False, e.stderr


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


def print_step_header(step_number, title):
    """Print formatted step header."""
    console.print()
    step_text = Text()
    step_text.append(f"[Step {step_number}] ", style="bold cyan")
    step_text.append(title, style="bold white")
    console.print(step_text)
    console.print("─" * 60, style="dim blue")


def print_success(message):
    """Print success message."""
    console.print(f"  ✓ {message}", style="green")


def print_error(message):
    """Print error message."""
    console.print(f"  ✗ {message}", style="red")


def collect_configuration():
    """Collect configuration from user."""
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
        return None
    
    # Verify project
    console.print()
    with Progress(
        SpinnerColumn(style="cyan"),
        TextColumn("[cyan]{task.description}[/cyan]"),
        console=console,
        transient=True
    ) as progress:
        progress.add_task("Verifying project access...", total=None)
        
        if not verify_project_access(config['project_id']):
            console.print()
            print_error(f"Cannot access project: {config['project_id']}")
            console.print("\n  [dim]Ensure project ID is correct and you have necessary permissions.[/dim]\n")
            return None
    
    console.print()
    print_success(f"Project verified: {config['project_id']}")
    
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
        return None
    
    console.print()
    print_success(f"Service name: {config['service_name']}")
    
    # Step 3: Region
    print_step_header(3, "Deployment Region")
    console.print()
    
    region_choice = questionary.select(
        "Select your deployment region:",
        choices=get_available_regions(),
        style=questionary.Style([
            ('question', 'bold cyan'),
            ('highlighted', 'bg:#0066cc fg:#ffffff bold'),
        ])
    ).ask()
    
    if not region_choice:
        return None
    
    config['region'] = region_choice.split(' ')[0]
    console.print()
    print_success(f"Region: {region_choice}")
    
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
        return None
    
    console.print()
    access_status = "Public access enabled" if config['allow_unauthenticated'] else "Authenticated access only"
    print_success(access_status)
    
    return config


def deploy_infrastructure(config):
    """Deploy infrastructure using Terraform."""
    console.print()
    console.print()
    console.print("═" * 90, style="bold blue")
    console.print("                          AUTOMATED DEPLOYMENT STARTING", style="bold white")
    console.print("═" * 90, style="bold blue")
    console.print()
    
    terraform_dir = Path("terraform")
    
    # Ensure authentication is fresh and project is set
    ensure_gcloud_auth(config['project_id'])
    
    # Step 1: Generate configuration
    console.print("[bold cyan]Stage 1:[/bold cyan] Generating Terraform configuration...")
    tfvars_path = generate_tfvars(config)
    print_success(f"Configuration saved: {tfvars_path}")
    time.sleep(0.5)
    
    # Step 2: Initialize Terraform
    console.print("\n[bold cyan]Stage 2:[/bold cyan] Initializing Terraform...")
    success, output = run_command(
        ["terraform", "init", "-upgrade"],
        cwd=terraform_dir,
        description="terraform init"
    )
    
    if not success:
        print_error("Terraform initialization failed")
        console.print(f"\n[red]{output}[/red]\n")
        return False
    
    print_success("Terraform initialized successfully")
    time.sleep(0.5)
    
    # Step 3: Terraform Plan
    console.print("\n[bold cyan]Stage 3:[/bold cyan] Planning infrastructure changes...")
    success, output = run_command(
        ["terraform", "plan", "-out=tfplan"],
        cwd=terraform_dir,
        description="terraform plan"
    )
    
    if not success:
        print_error("Terraform plan failed")
        console.print(f"\n[red]{output}[/red]\n")
        return False
    
    print_success("Infrastructure plan created")
    console.print(f"\n[dim]Review: Cloud Run service will be created in {config['region']}[/dim]")
    time.sleep(1)
    
    # Step 4: Confirm deployment
    console.print()
    proceed = questionary.confirm(
        "Deploy infrastructure now?",
        default=True,
        style=questionary.Style([
            ('question', 'bold yellow'),
            ('answer', 'bold white'),
        ])
    ).ask()
    
    if not proceed:
        console.print("\n[yellow]Deployment cancelled by user.[/yellow]\n")
        return False
    
    # Step 5: Apply
    console.print("\n[bold cyan]Stage 4:[/bold cyan] Deploying infrastructure...")
    console.print("[dim]This may take 60-90 seconds...[/dim]\n")
    
    # Prepare environment with fresh access token
    env = os.environ.copy()
    token_result = subprocess.run(
        ["gcloud", "auth", "print-access-token"],
        capture_output=True,
        text=True,
        timeout=10
    )
    if token_result.returncode == 0 and token_result.stdout.strip():
        env['GOOGLE_OAUTH_ACCESS_TOKEN'] = token_result.stdout.strip()
    
    with Progress(
        SpinnerColumn(style="cyan"),
        TextColumn("[cyan]{task.description}[/cyan]"),
        BarColumn(complete_style="green", finished_style="green"),
        console=console
    ) as progress:
        task = progress.add_task("Deploying Cloud Run service...", total=100)
        
        # Run terraform apply with fresh credentials
        process = subprocess.Popen(
            ["terraform", "apply", "-auto-approve", "tfplan"],
            cwd=terraform_dir,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            env=env
        )
        
        # Simulate progress
        for i in range(100):
            time.sleep(0.8)
            progress.update(task, advance=1)
            if process.poll() is not None:
                break
        
        process.wait()
        
        if process.returncode != 0:
            progress.stop()
            console.print()
            print_error("Deployment failed")
            stderr = process.stderr.read()
            console.print(f"\n[red]{stderr}[/red]\n")
            return False
    
    console.print()
    print_success("Infrastructure deployed successfully")
    
    # Step 6: Get service URL
    console.print("\n[bold cyan]Stage 5:[/bold cyan] Retrieving service information...")
    success, url = run_command(
        ["terraform", "output", "-raw", "service_url"],
        cwd=terraform_dir
    )
    
    if success and url.strip():
        console.print()
        console.print("═" * 90, style="bold green")
        console.print("                          DEPLOYMENT COMPLETE", style="bold white")
        console.print("═" * 90, style="bold green")
        console.print()
        
        # Display results
        result_panel = f"""
[bold white]Your service is now live![/bold white]

[bold cyan]Service URL:[/bold cyan]
  {url.strip()}

[bold cyan]Quick Commands:[/bold cyan]
  Test service:  curl {url.strip()}
  View logs:     gcloud logging read "resource.labels.service_name={config['service_name']}" --limit=20
  View service:  gcloud run services describe {config['service_name']} --region={config['region']}

[bold yellow]Cleanup:[/bold yellow]
  To remove resources: cd terraform && terraform destroy
"""
        
        console.print(Panel(
            result_panel,
            border_style="green",
            box=box.DOUBLE,
            padding=(1, 2)
        ))
        console.print()
        return True
    
    return True


def main():
    """Main deployment workflow."""
    print_welcome_banner()
    
    # Collect configuration
    config = collect_configuration()
    
    if not config:
        console.print("\n[yellow]Configuration cancelled.[/yellow]\n")
        sys.exit(0)
    
    # Show summary
    console.print()
    summary_table = Table(show_header=False, box=None, padding=(0, 2))
    summary_table.add_column("Setting", style="cyan", width=20)
    summary_table.add_column("Value", style="white")
    
    summary_table.add_row("Project ID", config['project_id'])
    summary_table.add_row("Service Name", config['service_name'])
    summary_table.add_row("Region", config['region'])
    summary_table.add_row(
        "Public Access",
        "Yes (Public)" if config['allow_unauthenticated'] else "No (Authenticated only)"
    )
    
    console.print(Panel(
        summary_table,
        title="[bold white]Configuration Summary[/bold white]",
        border_style="blue",
        box=box.ROUNDED,
        padding=(1, 2)
    ))
    
    # Deploy
    success = deploy_infrastructure(config)
    
    if success:
        sys.exit(0)
    else:
        sys.exit(1)


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        console.print("\n\n[yellow]Deployment cancelled by user.[/yellow]\n")
        sys.exit(0)
    except Exception as e:
        # Escape any Rich markup in the error message
        error_msg = str(e).replace("[", "\\[").replace("]", "\\]")
        console.print(f"\n\n[red]Error: {error_msg}[/red]\n")
        sys.exit(1)
