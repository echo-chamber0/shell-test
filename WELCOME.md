#  Welcome to Data Commons Deployment

## Getting Started

### Start the Deployment

Look at the **terminal below** ↓

**If the deployment tool is already running**, just answer the questions.

**If you see a command prompt `$`**, start the deployment by running:

```bash
python setup.py
```

---

## How to Deploy

1. **Start deployment** (run `python setup.py`)
2. **Answer 4 questions** (project, service name, region, access)
3. **Wait 2-3 minutes** (fully automated)
4. **Get your service URL** (displayed at the end)

---

## After Deployment

**To clean up and remove all resources:**

```bash
./cleanup.sh
```

This deletes the Cloud Run service and all deployed infrastructure.

---


