# COMP4000 Implementation Experience 1: Getting Started with Kubernetes

In this implementation experience, you will be configuring and deploying a simple "hello
world" Kubernetes cluster using `minikube`. While your cluster is not yet truly
"distributed", it behaves just as a real Kubernetes cluster would. For more information on
Kubernetes configuration, you may wish to consult the [k8s-docs][official documentation].
Links to specific documentation items will also be provided as hints later on in this
document.

With the exception of Part 2, completing this experience shouldn't take more than a couple
of hours. Feel free to collaborate with other students if you get stuck. However, **you must
acknowledge any collaboration**. Additionally, **copying and pasting or simply "changing
up" each other's answers will be treated as an academic integrity violation**.

[k8s-docs]: https://kubernetes.io/docs/concepts/

## Getting Started

To get started, you will need to run a few commands on your OpenStack course VM to set up
the environment. If you are not yet on OpenStack, please get set up as quickly as possible.
We have a [openstack][detailed setup guide available] if you need assistance.

1. SSH into your VM using your preferred SSH client. Remember that your username and
   password are both `student` by default.

2. If you haven't already, **change your password** with the `passwd` command.

3. Set up a simple minikube cluster using `minikube start`. After running this command,
   you should see some information printed to your terminal as minikube sets up your
   environment. Let the command run to completion.

4. Deploy the experience 1 configuration by running `kubectl apply -f deployment.yml`.
   This should download some container images and create the necessary Kubernetes API
   objects to run our simple "distributed" application.

[openstack]: https://homeostasis.scs.carleton.ca/wiki/index.php/DistOS_2021F:_Using_Openstack

## Part 1 (Easy)

Follow the instructions for each of the following numbered tasks. Make an effort to answer
the accompanying questions, but more importantly please note down all of your observations
and describe what you did for each task. You should also feel free to write down whatever
questions you may have about a given task.

To achieve the best possible grade in this section, you must demonstrate that you have
made an effort to understand the results of each task. (Note that an effort does not
strictly mean a full understanding; it is okay to have questions!)

1. Kubernetes deploys Linux containers as "Pods", which form an even higher-level
   abstraction around the container itself. In addition to Pods, Kubernetes supports
   several other API objects that abstract over various distributed systems concepts.
   The simple deployment you have installed uses a few of these API objects.

   Using `kubectl get <object type>`, `kubectl explain <object type>`, and `kubectl
   describe <object name>`, identify at least three different kinds of API object that are
   used in our deployment and briefly describe what they do. You can refer to `kubectl
   --help` as needed to explain what these commands do.

   Hint 1: Some resources are encapsulated by multiple layers of abstraction. Each "layer"
   counts as a unique type of object for the purposes of this question.

   Hint 2: The command `kubectl api-resources` will enumerate a full list of all supported API
   objects. You may also wish to consult [object-docs][the relevant documentation] if you
   are stuck.

   Hint 3: You may want to have a look at the contents of the `deployment.yml` file.

2. Run `kubectl get pods` to see a list of the pods that are running in your cluster. You
   should notice several `comp4000server` pods and one `comp4000client` pod. Spawn an
   interactive shell into the `comp4000client` pod using `kubectl exec comp4000client -it
   -- /bin/sh`. Examine the layout of your container's filesystem. What files and
   directories exist? Do you think these files exist on your VM or somewhere else? What
   commands can you run?

   Hint: Try running `cd ..` to leave the empty `/client` directory.

3. Our cluster exposes the `comp4000server` pods using a `NodePort` service. To find its IP
   address, start by spawning another terminal by starting another SSH session. (You
   should probably have _at least_ two terminals open for the rest of this experience.)
   In your second terminal, run `kubectl get services` and copy the `CLUSTER-IP` next to
   the `NodePort` service.

   From inside your `comp4000client` container, use `curl <IP address here>`
   to send a GET request to the `NodePort` service. Repeat the same command a few
   different times. What do you notice about the output? Explain.

   Hint: Try running `kubectl get pods` again to refresh your memory about the topology of our cluster.

4. The simple web server running behind our `NodePort` service exposes a convenient end
   point called `/crashme` that bricks the server. Try calling this end point several
   times like `for i in $(seq 1 20); do curl <IP address here>/crashme; done`, then try
   interacting with the servers after a few moments.

   Repeat the same experiment, but this time run `kubectl get pods -w` in another terminal
   to watch the status of your pods in real time. What do you think is happening? Try to
   come up with an explanation for the behaviour you see.

5. Another end point `/count` returns a count of how many GET requests the server has
   processed. Try spamming our `NodePort` with requests to `/count` like `for i in $(seq
   1 10000); do curl <IP address here>/count; done`. What do you notice about the count
   for each server? Try to explain what you see.

   Hint: Think all the way back to the second question.

6. Try scaling up the replication count of `comp4000server`. You can do this using
   `kubectl scale deployment comp4000server --replicas <n>` where `<n>` is a number of
   your choosing. Try this a few different times with different numbers and examine the
   output of `kubectl get pods` each time. You might also want to try repeating some of
   the earlier exercises with your newly scaled deployment.

[object-docs]: https://kubernetes.io/docs/concepts/workloads/pods/

## Part 2: Deploying a Custom Container Image (Hard)

The simple web server for this experience has one last end point: `/printerfacts`. Making
an HTTP GET request to this end point returns some totally non-suspicious facts about
printers. Your task is to write a simple client application (in any language of your
choosing) to consume the `printerfacts` API in some way. Feel free to be as creative
as you like.

Once you have written your application, containerize it and deploy it to your cluster in
any way you see fit. For example, you may wish to replicate it, make it stateful (e.g.
persist a simple database), or expose it to the outside world using a `LoadBalancer`
service.

Tell us about what you did and how you did it. In particular, we want to hear about the
parts you had difficulty with, any ideas you had that didn't pan out, what ended up
working, and how your deployment fits together with the rest of the cluster.

Points for this question will be awarded based on:
a) The sophistication of your deployment. (Challenge yourself!)
b) The quality of your explanation.

Here are some hints to help you get started:
a) When you are creating your container image, you need to take extra care to ensure
   Kubernetes uses your local image. To do this, run `eval $(minikube docker-env)` before
   running any `docker` commands in your shell. In your `deployment.yml`, set
   `imagePullPolicy: Never` under the `container` field to force it to use your local
   image.
b) You can create a new container image by writing a Dockerfile for it and running `docker
   build -t <name> .` to build it.
c) You can modify the `deployment.yml` file to create your API object, then re-deploy it
   by running the same `kubectl apply -f` command from earlier. Feel free to copy-paste
   and/or modify any of the existing configuration.

## Part 3: Reflection

Summarize your experience with Kubernetes in a few paragraphs (both the good and the bad).
What concepts do you see reflected here from the research papers we have read thus far?
After having some hands on experience with a distributed system technology, have any of
your opinions or initial assumptions changed? Feel free to list any other thoughts you have.
