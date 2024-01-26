pipeline {
    agent {
        label 'any'
    }
    stages {
        stage('Checkout main branch') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: 'origin/main']], userRemoteConfigs: [[url: 'https://github.com/Noorunnsa/Jenkins-K8s-Nginx.git']]])
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
     stage('Push updated manifest to bitbucket') {
      steps {
        sh 'git add manifests/deployment.yml && git commit -m "updated manifest after build" manifests/deployment.yml && git push origin main'
      }
     }
     stage('Deploy to K8s') {
      steps{
        script {
          sh "cat manifests/deployment.ymml"
          sh "kubectl get pods"
          sh "kubectl create -f manifests/deployment.yml"
          sh "kubectl create -f manifests/service.yml"
          sh "kubectl create -f manifests/configmap.yml"
          sh "minikube service nginx-service"
        }
      }
    }

    }
}
