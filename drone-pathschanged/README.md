# drone-pathschanged-helm

An unofficial helm chart for [meltwater/drone-convert-pathschanged](https://github.com/meltwater/drone-convert-pathschanged). For instructions on how to configure the required environment values please consult that link. You'll need:
```
env:
  PROVIDER: <value>
  TOKEN: <value>
  DRONE_SECRET: <value>
```

## Chart configuration


Please consult the [values](/drone-pathschanged/values.yaml) for the standard configuration for a deployment in kubernetes. 

Configuring the app deployed by this chart can be done in three ways:
- env vars in the values file (highly discouraged)
- env vars via secrets
- load a file by providing a custom command to the container

### Env vars configuration

```
...
env:
  DRONE_DEBUG: false
  DRONE_SECRET: insecure_value_in_source_code
  TOKEN: insecure_value_in_source_code
  PROVIDER: github
...
```

### Env from secrets

```
...
env:
  PROVIDER: github
  DRONE_DEBUG: true

extraSecretEnvironmentVars:
  - envName: TOKEN
    secretName: drone-convert-pathschanged
    secretKey: token
  - envName: DRONE_SECRET
    secretName: drone-convert-pathschanged
    secretKey: secret
...
```

### Env from a file

Currently only `pwd`/.env is a valid path from where to load env vars, so copy your file containing the env vars to that path and execute the binary.

```
...
image:
  command:
    - sh
    - c
    - cp /path/to/secrets /.env && /bin/drone-convert-pathschanged

env:
  PROVIDER: github
  DRONE_DEBUG: true

extraVolumes: ...
extraVolumeMounts: ...

podAnnotations: ... (vault use-case)
```
