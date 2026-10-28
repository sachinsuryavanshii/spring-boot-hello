# Spring Boot Hello - Kubernetes & Jenkins CI/CD Pipeline

A complete Spring Boot project demonstrating containerization, Kubernetes orchestration, Git version control, and Jenkins automation.

---

## Architecture & Tech Stack

| Component | Technology | Version / Configuration |
| :--- | :--- | :--- |
| **Backend Framework** | Spring Boot | 3.3.5 (Spring Web, Spring Test) |
| **Language/Compiler** | Java (JDK 25) | Target release `21` for container compatibility |
| **Build Tool** | Apache Maven | 3.9.11 |
| **Container Engine** | Docker Desktop | `eclipse-temurin:21-jre-alpine` |
| **Container Orchestration** | Kubernetes (Minikube) | Deployment (2 replicas) & NodePort Service |
| **CI/CD Automation** | Jenkins Pipeline | 5 stages: Checkout, Build, Test, Docker Build, Deploy |

---

## Project Structure

```text
DAY-27/
├── src/
│   ├── main/
│   │   ├── java/com/example/hello/
│   │   │   ├── HelloApplication.java
│   │   │   └── controller/
│   │   │       └── HelloController.java
│   │   └── resources/
│   │       └── application.properties
│   └── test/
│       └── java/com/example/hello/
│           ├── HelloApplicationTests.java
│           └── controller/
│               └── HelloControllerTest.java
├── pom.xml
├── Dockerfile
├── deployment.yaml
├── service.yaml
├── Jenkinsfile
├── .gitignore
└── README.md
```

---

## Step-by-Step Instructions

### Step 1: Endpoint & Verification
- Endpoint: `GET http://localhost:8080/hello`
- Default Response: `Hello, World!`
- Parameterized: `GET http://localhost:8080/hello?name=Antigravity` -> `Hello, Antigravity!`

### Step 2: Maven Build
```powershell
mvn clean package
```
Generates executable JAR: `target/spring-boot-hello-0.0.1-SNAPSHOT.jar`.

### Step 3: Docker Build & Run
```powershell
# Build image
docker build -t spring-boot-hello:1.0.0 .

# Run container
docker run -d -p 8080:8080 --name spring-boot-hello-app spring-boot-hello:1.0.0

# Verify
curl http://localhost:8080/hello
```

### Step 4: Kubernetes Deployment (Minikube)
```powershell
# Point Docker CLI to Minikube's Docker daemon (optional for local image)
minikube image load spring-boot-hello:1.0.0

# Apply Kubernetes manifests
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

# Check pods & service
kubectl get pods -l app=spring-boot-hello
kubectl get svc spring-boot-hello-service

# Access via Minikube
minikube service spring-boot-hello-service --url
```

### Step 5: Git & GitHub Commands
```bash
git init
git add .
git commit -m "feat: Initial commit for Spring Boot hello service with Docker, K8s, and Jenkinsfile"
git branch -M main
git remote add origin https://github.com/<your-username>/<your-repo-name>.git
git push -u origin main
```

### Step 6: Jenkins CI/CD Pipeline
The `Jenkinsfile` in the project root defines the automated pipeline:
1. **Checkout**: Pulls latest code from Git.
2. **Build**: Compiles & packages the JAR with Maven (`mvn clean compile package -DskipTests`).
3. **Test**: Executes unit and integration tests (`mvn test`).
4. **Docker Build**: Packages the JAR into a container image (`docker build -t spring-boot-hello:1.0.0 .`).
5. **Deploy to Kubernetes**: Applies manifests and verifies rollout status (`kubectl apply -f deployment.yaml && kubectl apply -f service.yaml`).
