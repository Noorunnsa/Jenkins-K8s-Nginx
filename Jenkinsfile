pipeline {
    agent any
    stages {
        stage('Checkout main branch') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: 'origin/main']], userRemoteConfigs: [[url: 'https://github.com/Noorunnsa/Jenkins-K8s-Nginx.git']]])
            }
        }
      stage('SonarQube Analysis') {
         steps {
             script {
                 def scannerHome = tool 'SonarQubeScanner'
                 withSonarQubeEnv('sonarqube') {
                   sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=Sonar_Jenkins -Dsonar.host.url=http://3.109.121.112:9000/ -Dsonar.login=sqp_2e4287ed45f2a666e84b2e7365d1ae932097b83c"
                 }
               }
             }
        }
     stage("Quality Gate") {
       steps {
               timeout(time: 5, unit: 'MINUTES') {
                 waitForQualityGate abortPipeline: true
             }
         }
     }
        stage('Build Docker Image') {
            steps {
          sh "docker build -t noorunnisa/jenkins-k8s-nginx:${BUILD_NUMBER} ."
          sh "docker images"
          sh "sleep 10"
            }
        }
        stage('Test Docker Image') {
      steps {
          sh "docker run -d -p 80:80 --name nginx noorunnisa/jenkins-k8s-nginx:${BUILD_NUMBER}"
          sh "sleep 10"
          sh "docker rm -f nginx"
          sh "echo testing complete"
        }
      }
      stage('Push Docker Image To Repo') {
      steps {
          sh "docker login -u noorunnisa -p Noorunnisa@docker"
          sh "docker push noorunnisa/jenkins-k8s-nginx:${BUILD_NUMBER}"
          sh "echo =============Successfully pushed docker image============"
          sh "docker logout"
        }
      }
      stage('modify manifest tag') {
      steps {
        sh "sed -i -e 's%noorunnisa/jenkins-k8s-nginx:.*%noorunnisa/jenkins-k8s-nginx:${BUILD_NUMBER}%g' manifests/deployment.yml"
        sh 'cat manifests/deployment.yml'
      }
    }
     stage('Deploy to K8s') {
      steps{
        script {
          sh "cat manifests/deployment.yml"
          sh "minikube delete --all"
          sh "./setup.sh"
          sh "kubectl cluster-info"
          sh "sleep 10"
          sh "kubectl create -f manifests/deployment.yml"
          sh "kubectl create -f manifests/service.yml"
          sh "kubectl create -f manifests/configmap.yml"
          sh "kubectl get pods"
          sh "sleep 60"
          sh "minikube service nginx-service"
        }
      }
    }

    }
}

