# Deploy Nginx on Google Cloud Run

## Welcome! 👋

Welcome to this **interactive tutorial** for deploying nginx on Google Cloud Run!

By the end of this tutorial, you'll have:
- ✅ A running nginx web server on Cloud Run
- ✅ A public HTTPS URL to access your service
- ✅ Hands-on experience with Terraform and GCP

**⏱ Time to complete:** ~10 minutes  
**💰 Cost:** Free tier eligible (no charges for low traffic)

<walkthrough-tutorial-duration duration="10"></walkthrough-tutorial-duration>

Click **Next** to begin your Cloud Run journey! 🚀

---

## What is Cloud Run? ☁️

Cloud Run is Google Cloud's **fully managed serverless platform** for deploying containerized applications.

### Key Benefits:

- 🚀 **Auto-scaling** - Scales from 0 to N instances automatically
- 💰 **Pay-per-use** - Only charged for actual request time (down to 100ms)
- 🔒 **Built-in HTTPS** - Automatic SSL certificates
- 🌍 **Global deployment** - Multiple regions available
- 🐳 **Any language** - Runs any containerized application

### What We'll Deploy:

In this tutorial, we'll deploy a simple **nginx web server** as a Cloud Run service. This demonstrates the core concepts that apply to any containerized application.

**Click Next to start the setup.** ⏭

---

## Step 1: Install Python Dependencies 📦

First, let's install the Python libraries needed for our **beautiful interactive configuration script**.

Run the following command in Cloud Shell:

```bash
pip install -r requirements.txt
```

This installs:
- **rich** - Beautiful terminal formatting and progress bars
- **questionary** - Interactive prompts with validation
- **python-dotenv** - Environment variable management (optional)

### What to Expect:

You'll see pip downloading and installing the packages. This takes about 10-20 seconds.

**✅ Wait for "Successfully installed..." message, then click Next.**

---

## Step 2: Run Interactive Setup 🎨

Now for the fun part! Run our **interactive setup script** to configure your deployment:

```bash
python setup.py
```

### You'll Be Asked For:

1. **GCP Project ID** - The project where resources will be created
2. **Service Name** - A name for your Cloud Run service (e.g., "nginx-demo")
3. **Region** - Where to deploy (e.g., us-central1)
4. **Public Access** - Whether to allow unauthenticated requests

### Features You'll See:

- 🎨 **Beautiful UI** with colors and panels
- ✅ **Real-time validation** of your inputs
- 🔍 **Project verification** before proceeding
- 📊 **Configuration summary** before saving

### Example Values:

- **Project ID:** `my-project-12345` (use your actual project)
- **Service Name:** `nginx-demo`
- **Region:** `us-central1`
- **Public Access:** `Yes`

**Follow the prompts and answer each question. The script will validate your inputs and check GCP project access.**

Once you see "🎉 Setup Complete!", click **Next**.

---

## Step 3: Review Configuration 📋

Great! Your configuration has been saved to `terraform/terraform.tfvars`.

Let's review what will be created:

```bash
cat terraform/terraform.tfvars
```

### What You'll See:

```hcl
project_id = "your-project-id"
service_name = "nginx-demo"
region = "us-central1"
allow_unauthenticated = true
container_image = "gcr.io/cloudrun/hello"
```

### Configuration Explained:

- **project_id** - Your GCP project
- **service_name** - Name of the Cloud Run service
- **region** - Deployment location
- **allow_unauthenticated** - Public access (true/false)
- **container_image** - Container to deploy (nginx hello world)

### Need to Make Changes?

If you want to modify any values:
- **Option 1:** Run `python setup.py` again
- **Option 2:** Manually edit `terraform/terraform.tfvars` with Cloud Shell editor

<walkthrough-editor-open-file filePath="terraform/terraform.tfvars">
Open terraform.tfvars in editor
</walkthrough-editor-open-file>

**Click Next when you're satisfied with the configuration.** ⏭

---

## Step 4: Initialize Terraform 🔧

Now let's initialize Terraform to download the GCP provider plugin:

```bash
cd terraform
terraform init
```

### What This Does:

1. Downloads the **Google Cloud provider** plugin
2. Sets up the **Terraform backend** (local state)
3. Prepares the working directory for deployment

### Expected Output:

```
Initializing the backend...
Initializing provider plugins...
- Finding latest version of hashicorp/google...
- Installing hashicorp/google v5.x.x...
- Installed hashicorp/google v5.x.x

Terraform has been successfully initialized!
```

**✅ Wait for "Terraform has been successfully initialized!" then click Next.**

---

## Step 5: Preview Infrastructure Changes 👀

Before deploying, let's see what Terraform will create:

```bash
terraform plan
```

### What This Command Does:

- **Analyzes** your Terraform configuration
- **Compares** with current GCP state
- **Shows** what will be created, modified, or destroyed

### Expected Output:

You should see something like:

```
Terraform will perform the following actions:

  # google_cloud_run_service.nginx will be created
  + resource "google_cloud_run_service" "nginx" {
      + name     = "nginx-demo"
      + location = "us-central1"
      ...
    }

  # google_cloud_run_service_iam_member.public_access will be created
  + resource "google_cloud_run_service_iam_member" "public_access" {
      + role   = "roles/run.invoker"
      + member = "allUsers"
      ...
    }

Plan: 2 to add, 0 to change, 0 to destroy.
```

### What Will Be Created:

1. **Cloud Run Service** - The nginx container service
2. **IAM Binding** - Public access permission (if enabled)

**⚠️ Important:** Review the plan carefully. Make sure everything looks correct.

**Click Next to proceed with deployment.** ⏭

---

## Step 6: Deploy Infrastructure 🚀

Time to deploy! Run:

```bash
terraform apply
```

When prompted, type `yes` to confirm.

### What Terraform Will Do:

1. ✅ Create the Cloud Run service
2. ✅ Deploy the nginx container
3. ✅ Configure networking and IAM
4. ✅ Output the service URL

### Expected Duration:

⏱ **2-3 minutes** - Grab a coffee! ☕

### What You'll See:

```
google_cloud_run_service.nginx: Creating...
google_cloud_run_service.nginx: Still creating... [10s elapsed]
google_cloud_run_service.nginx: Creation complete after 45s

google_cloud_run_service_iam_member.public_access: Creating...
google_cloud_run_service_iam_member.public_access: Creation complete after 5s

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

service_url = "https://nginx-demo-xyz123-uc.a.run.app"
```

**✅ Wait for "Apply complete!" message, then click Next.**

---

## Step 7: Access Your Service 🌐

🎉 **Congratulations!** Your nginx service is now live on the internet!

### Get the Service URL:

```bash
terraform output service_url
```

### Test Your Service:

**Option 1: Browser**

Click the URL shown in the output (or copy/paste into your browser).

**Option 2: Command Line**

```bash
curl $(terraform output -raw service_url)
```

### What You Should See:

```html
<!DOCTYPE html>
<html>
<head>
  <title>Cloud Run - Hello World</title>
</head>
<body>
  <h1>Hello from Cloud Run!</h1>
  <p>This service is deployed via Terraform.</p>
</body>
</html>
```

### Your Service Details:

- **🌐 URL:** `https://your-service-xxx.a.run.app`
- **🔒 Protocol:** HTTPS (automatic SSL)
- **📍 Region:** Where you deployed
- **⚡ Scaling:** 0 to 10 instances (automatic)

**✨ Success! Your nginx service is running on Cloud Run!**

**Click Next to learn about cleanup.** ⏭

---

## Step 8: Explore Your Service (Optional) 🔍

Before cleaning up, let's explore what was created in the GCP Console.

### View in Cloud Console:

**Option 1: Command Line**

```bash
gcloud run services describe $(terraform output -raw service_name) \
  --region=$(terraform output -raw service_location) \
  --format=yaml
```

**Option 2: GCP Console UI**

<walkthrough-menu-navigation sectionId="CLOUD_RUN_SECTION"></walkthrough-menu-navigation>

Open Cloud Run in Console (click above), then:

1. Find your service (e.g., "nginx-demo")
2. Click on it to see details
3. Explore the **Revisions**, **Metrics**, and **Logs** tabs

### Cool Things to Check:

- **📊 Metrics** - Request count, latency, instance count
- **📝 Logs** - Real-time application logs
- **🔧 Configuration** - CPU, memory, scaling settings
- **🔐 Permissions** - IAM policy (public access)

### Try Some Requests:

Generate traffic to see metrics:

```bash
for i in {1..10}; do curl -s $(terraform output -raw service_url) > /dev/null; echo "Request $i sent"; done
```

Watch the metrics update in the console! 📈

**Click Next when ready to clean up.** ⏭

---

## Step 9: Cleanup Resources 🧹

To avoid any charges, let's delete all created resources.

### Why Clean Up?

- 💰 Prevents unexpected charges
- 🧹 Keeps your GCP project organized
- ♻️ Best practice for demos and testing

### Option 1: Using Cleanup Script

From the repository root:

```bash
cd ..
./cleanup.sh
```

The script will:
1. Ask for confirmation (safety check)
2. Run `terraform destroy`
3. Delete all resources

### Option 2: Manual Terraform Destroy

```bash
terraform destroy
```

Type `yes` when prompted.

### What Will Be Deleted:

```
Plan: 0 to add, 0 to change, 2 to destroy.

google_cloud_run_service_iam_member.public_access: Destroying...
google_cloud_run_service_iam_member.public_access: Destruction complete after 3s
google_cloud_run_service.nginx: Destroying...
google_cloud_run_service.nginx: Destruction complete after 8s

Destroy complete! Resources: 2 destroyed.
```

### Expected Duration:

⏱ **10-15 seconds**

**✅ Wait for "Destroy complete!" message, then click Next for the summary.**

---

## Congratulations! 🎊🎉

You've successfully completed the Cloud Run with Terraform tutorial!

### What You Accomplished:

- ✅ Configured a GCP deployment with a **beautiful interactive CLI**
- ✅ Used **Terraform** to provision cloud infrastructure
- ✅ Deployed a **containerized application** to Cloud Run
- ✅ Accessed your **live service** on the internet
- ✅ Learned **infrastructure cleanup** best practices

### Skills You Practiced:

- 🐍 Python CLI development with **rich** and **questionary**
- ☁️ GCP Cloud Run serverless platform
- 🏗️ Infrastructure as Code with **Terraform**
- 🐳 Container deployment
- 🔐 IAM permissions management

---

## Next Steps 🚀

### 1. Extend This Project:

- 🐳 **Custom Container** - Build your own Docker image
- 🗄️ **Add Database** - Connect Cloud SQL
- 🔐 **Secrets Management** - Use Secret Manager
- 🌐 **Custom Domain** - Map your domain to Cloud Run
- 🔄 **CI/CD Pipeline** - Automate with Cloud Build
- 📊 **Monitoring** - Set up Cloud Monitoring alerts

### 2. Learn More:

**Official Documentation:**
- [Cloud Run Documentation](https://cloud.google.com/run/docs)
- [Terraform GCP Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [Cloud Run Pricing](https://cloud.google.com/run/pricing)

**Tutorials:**
- [Deploy a Web Service](https://cloud.google.com/run/docs/quickstarts/build-and-deploy)
- [Continuous Deployment](https://cloud.google.com/run/docs/continuous-deployment)
- [Terraform on GCP](https://cloud.google.com/docs/terraform)

**Tools:**
- [Python Rich Library](https://rich.readthedocs.io/)
- [Questionary Docs](https://questionary.readthedocs.io/)

### 3. Try Other GCP Services:

- **Cloud Functions** - Event-driven serverless
- **GKE (Kubernetes)** - Full container orchestration
- **App Engine** - Platform-as-a-Service
- **Cloud Build** - CI/CD pipelines
- **Artifact Registry** - Container image storage

---

## Share Your Success! 📢

Did you enjoy this tutorial?

- ⭐ **Star this repository** on GitHub
- 🐦 **Share on social media** - Tag @googlecloud
- 💬 **Provide feedback** - Open an issue or PR
- 📝 **Write about it** - Blog post or tutorial

---

## Support & Community 🤝

Need help or have questions?

- 📚 [Stack Overflow](https://stackoverflow.com/questions/tagged/google-cloud-run) - Tag: `google-cloud-run`
- 💬 [Google Cloud Community](https://www.googlecloudcommunity.com/)
- 🐛 [Report Issues](https://github.com/Arturio93/shell-test/issues)

---

## Thank You! 🙏

Thank you for completing this interactive tutorial!

We hope you enjoyed the experience and learned something valuable about:
- Google Cloud Run
- Infrastructure as Code
- Interactive CLI development

**Happy Cloud Computing!** ☁️🚀

---

**Made with ❤️ for Google Cloud Platform**

<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>

