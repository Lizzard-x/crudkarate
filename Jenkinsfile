pipeline {
  agent any

  options {
    timestamps()
    buildDiscarder(logRotator(numToKeepStr: '20'))
  }

  environment {

    GRADLE_USER_HOME = "${WORKSPACE}/.gradle"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build & Test (Karate)') {
        steps {
            bat 'gradlew.bat clean test --no-daemon'
        }
    }
      post {
        always {
          // JUnit results (ajusta si tu runner genera otro path)
          junit allowEmptyResults: true, testResults: '**/build/test-results/test/*.xml'

          // Guarda reportes / logs como artefactos
          archiveArtifacts allowEmptyArchive: true, artifacts: '**/build/reports/**, **/build/karate-reports/**, **/build/surefire-reports/**'

          // Publica HTML (Karate normalmente genera HTML en build/karate-reports)
          publishHTML(target: [
            allowMissing: true,
            alwaysLinkToLastBuild: true,
            keepAll: true,
            reportDir: 'build/karate-reports',
            reportFiles: 'karate-summary.html, index.html',
            reportName: 'Karate Report'
          ])
        }
      }
    }
  }

  post {
    success { echo '✅ Pipeline OK' }
    failure { echo '❌ Pipeline falló (mira el stage de Test y el reporte HTML)' }
    cleanup {
      cleanWs(deleteDirs: true, disableDeferredWipeout: true)
    }
  }
}