local components = [
  { name: 'drone' },
  { name: 'drone-runner-kube' }
];

local Pipeline(component) = {
  kind: "pipeline",
  type: "kubernetes",
  name: component.name,
  platform: {
    os: "linux",
    arch: "arm64"
  },
  trigger: {
    paths: [
      component.name + "/*"
    ]
  },
  [if std.objectHas(component, 'depends_on') then 'depends_on']: component.depends_on,
  steps: [
    {
      name: "Package and push chart",
      image: "registry.192.168.178.48.nip.io/cluster-droid:0.1.2",
      commands: [
        'helm lint ' + component.name + '/',
        'helm package ' + component.name + '/',
        'curl -X POST --data-binary @' + component.name + '-`cat ' + component.name + '/Chart.yaml | grep "version:" | cut -d " " -f 2`.tgz -k https://charts.192.168.178.48.xip.io/api/charts'
      ]
    }
  ]
};

[ Pipeline(component) for component in components ]