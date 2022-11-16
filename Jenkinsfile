pipeline {
    
 agent any
 
 tools {
    maven 'MavenLatest'
 }
 
 environment {
     registry = '668806726900.dkr.ecr.eu-west-3.amazonaws.com/cicd-ecr'
     registryCredential =  'jenkins-ecr-user-credential'
     dockerimage = ''
 }
 
 stages {
     
    stage('Checkout the project') {
        steps {
             git branch: 'pipeline', url: 'https://github.com/oadya/cicd-project-test.git'
        }
    }
    
    stage('Build the pacjakge') {
        steps {
                sh 'mvn clean package'
        }
    }
    
    stage("Sonar Quality Check") {
        steps {
            script{
              withSonarQubeEnv(installationName : 'SonarQubeLocalServer', credentialsId : 'sonartoken') {
                sh 'mvn sonar:sonar'
              }
            timeout(time: 1, unit: 'HOURS') {
              def qg = waitForQualityGate()
              if (qg.status != 'OK') {
                  error "Pipeline aborted due to quality gate failure: ${qg.status}"
              }
            }
           }
        }
    }

    stage("Building the image") {
        steps {
            script {
               dockerImage = docker.build registry + ":$BUILD_NUMBER"
            }
        }
    }
    
    stage('Deploy Image to AWS ECR') {
        steps{
            script {
                docker.withRegistry( "http://" + registry, "ecr:eu-west-3:" + registryCredential ){
                dockerImage.push()
                }
            }
        }
    }
  }
  
     post {
       success {
        mail bcc: '', subject: "Pipeline succes", body: "Pipeline build successfully", cc: '', from: 'orphe.adya@gmail.com', to: 'orphe.adya@gmail.com', replyTo: ''			 
      }
      failure {
          mail bcc: '', subject: "Pipeline failled", body: "Pipeline failled", cc: '', from: 'orphe.adya@gmail.com', to: 'orphe.adya@gmail.com', replyTo: ''
      }
    }
}
