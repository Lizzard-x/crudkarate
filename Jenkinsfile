pipeline {
  agent any

  options {
    timestamps()
    buildDiscarder(logRotator(numToKeepStr: '20'))
  }

  environment {
    GRADLE_USER_HOME = "${WORKSPACE}\\.gradle"
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

      post {
        always {
          // Resultados JUnit
          junit allowEmptyResults: true, testResults: '**/build/test-results/test/*.xml'

          // Artefactos (reportes / logs)
          archiveArtifacts allowEmptyArchive: true,
            artifacts: '**/build/reports/**, **/build/karate-reports/**, **/build/test-results/**'

          // Reporte HTML Karate (si existe)
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
    failure { echo '❌ Pipeline falló (revisa Console Output y Test Results)' }
    cleanup {
      cleanWs(deleteDirs: true, disableDeferredWipeout: true)
    }
  }
}