

# 🐳 Self-Hosted GitHub Actions Runner for Terraform Deployments

This project provides a Dockerized self-hosted GitHub Actions runner that executes **Terraform-based infrastructure deployments** when a pull request is **merged into `dev`, `stage`, or `main` branches**.

---

## 📦 What’s Inside

* Docker image for a self-hosted GitHub Actions runner
* Workflow that runs **Terraform** on PR merge
* Branch-based environment setup (`dev`, `stage`, `main`)
* Auto-installs Terraform if needed
* Supports Node.js 18 setup (optional)

---

## 🚀 Getting Started

### 1. Clone this repo

```bash
git clone https://github.com/your-org/your-repo.git
cd your-repo
```

---

### 2. Build and Run Docker Runner Locally

```bash
docker build -t github-runner .
docker run -d --name self-hosted-runner \
  -e REPO_URL=https://github.com/your-org/your-repo \
  -e RUNNER_TOKEN=your_github_runner_token \
  -e RUNNER_NAME=my-runner \
  -e RUNNER_LABELS=self-hosted \
  -v /var/run/docker.sock:/var/run/docker.sock \
  github-runner
```

> **🔐 Get your `RUNNER_TOKEN` from GitHub repository settings → Actions → Runners → Add Runner**

---

## ⚙️ GitHub Actions Workflow

### 📄 `.github/workflows/terraform-deploy.yml`

This workflow is triggered when a pull request is **merged (closed and merged)** into the `dev`, `stage`, or `main` branches.

### ✅ Trigger Condition

```yaml
on:
  pull_request:
    types: [closed]
    branches:
      - dev
      - stage
      - main
```

It ensures the workflow only runs **after a successful merge**:

```yaml
if: github.event.pull_request.merged == true
```

---

## 🌍 Environment Configuration

### Required GitHub Secrets:

| Name              | Description                         |
| ----------------- | ----------------------------------- |
| `AWS_ACCESS_KEY`  | Your AWS access key                 |
| `AWS_SECRET_KEY`  | Your AWS secret key                 |


---

## 🔧 Runner Behavior

### Workflow Steps:

1. **Checks out repo**
2. **Checks if Terraform is installed**
3. Installs **Terraform if missing**
4. Installs **Node.js 18**
5. Detects target environment from the PR base branch:

   * `dev` → `ENV=development`
   * `stage` → `ENV=stage`
   * `main` → `ENV=production`
6. Runs **Terraform init/plan** commands only for `dev` currently
7. (Commented: future apply/destroy actions)

---

## 🛠 Directory Structure (Expected)

Ensure your Terraform folder structure supports the following command pattern:

```
cd /home/github/actions-runner/_work/walkthrough/walkthrough
./run dev network init -var-file=../dev.tfvars
./run dev network plan -var-file=../dev.tfvars -out=../tfplan
```

Customize these paths to match your project structure.

---

## 🧪 Example PR Flow

1. Create a PR from `feature/my-change` → `dev`
2. Merge the PR
3. Workflow triggers
4. Runner initializes Terraform for the `dev` environment

---

## 🧼 Cleanup (Optional)

To stop or remove the self-hosted runner:

```bash
docker stop self-hosted-runner
docker rm self-hosted-runner
```

---

## ❓ Notes

* Be sure Docker is installed and running locally.
* GitHub-hosted runners **won’t run** this—only your **Docker self-hosted runner** will.
* This setup is ideal for **CI environments with fine-grained Terraform control**.


