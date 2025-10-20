# Non-Cloud OpenTofu helper modules

These modules don't rely on any cloud providers. They're usually very small and as such are not split into several files like {main,variables,output}.tf.

## Modules

### zip
Create zip archives from one or more source files. Optionally supply template variables which are injected/substituted into the source code before archiving.

### tls
Create a cryptographic key pair and return the PEM values.