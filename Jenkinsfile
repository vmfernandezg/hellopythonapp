node {
  stage('build & deploy') {
    openshiftBuild bldCfg: 'hellopythonapp',
      namespace: 'development',
      showBuildLogs: 'true'
    openshiftVerifyDeployment depCfg: 'hellopythonapp',
      namespace: 'development'
  }

  stage('deploy to test') {
    openshiftTag srcStream: 'hellopythonapp',
      namespace: 'development',
      srcTag: 'latest',
      destinationNamespace: 'testing',
      destStream: 'hellopythonapp',
      destTag: 'test'
    openshiftVerifyDeployment depCfg: 'hellopythonapp',
      namespace: 'testing'
  }

  stage('deploy to production') {
    openshiftTag srcStream: 'hellopythonapp',
      namespace: 'development',
      srcTag: 'latest',
      destinationNamespace: 'production',
      destStream: 'hellopythonapp',
      destTag: 'prod'
    openshiftVerifyDeployment depCfg: 'hellopythonapp',
      namespace: 'production'
  }
}
