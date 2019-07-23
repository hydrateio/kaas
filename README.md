# Kubernetes as a Service

A large financial client recently asked us to produce a proof of concept to deliver Kubernetes to their organization. Not only did we deliver Kubernetes, we gave them Kubernetes as Service (as a service).  This repository is a sharing of that proof of concept.

## Components

### terraform

We use [terraform](http://terraform.io) to lay down ssh keys, s3 buckets, initial SSL certificates and networks into AWS. Terraform is a great tool that provides a desired state language that can be used to express our configuration desires across many cloud providers and technologies.

### rancher

We then deploy [rancher](https://rancher.com), a Kubernetes cluster manager that provides central authentication and role-based access to clusters and also can provision clusters to:

* AWS
* Azure
* vSphere
* many others

It also has a [terraform provider](https://www.terraform.io/docs/providers/rancher2/index.html) which will allow us to speak 'terraform' to our Rancher server to request and configure a Kubernetes cluster.

### atlantis

In addition, we deploy [atlantis](http://runatlantis.io) into our AWS account using fargate. Atlantis provides a git-based workflow to using terraform in addition to providing project locking so that multiple users can have multiple terraform changes 'in flight'.

## Request a k8s cluster... using a pull request

At this point, we have atlantis listenting for changes to our infracode. 

To request a new kubernetes cluster, provisioned by our rancher cluster manager we'd create a PR with this addition to the 'clusters' directory:

```hcl
module "crucial-sandbox" {
  source            = "../modules/aws-rancher-cluster"
  name              = "crucial-sandbox"
  vpc_id            = "${data.terraform_remote_state.main.vpc_id}"
  public_subnet_ids = "${data.terraform_remote_state.main.public_subnet_ids}"
  private_subnet_ids = "${data.terraform_remote_state.main.private_subnet_ids}"
  instance_type = "t2.medium"
  worker_num = "2"
}
```

This is an invocation of the aws-rancher-cluster module from our 'modules' directory. We're passing in general network and cluster sizing information while the gory details of provisioning the cluster are handled by terraform hitting the Rancher API and Rancher doing the heavy lifting.

After the PR is approved and the magic words `atlantis apply` are invoked in the PR comments, atlantis will `apply` our change and Rancher will create some new ec2 instances running RancherOS and bootstrap a kubernetes cluster onto them.

## KaaSaaS?

This whole 'cookie cutter' could be re-used multiple times, providing individual teams, organizations, companies, etc with therir very own, personalized KaaS.

