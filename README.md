Perfect 👍 — you’re actually in a **really good position** because that means you have two separate playbooks:

* `docker-swarm.yml` → sets up your **Docker cluster**
* `k8s-cluster.yml` → sets up your **Kubernetes cluster**

Let’s go through exactly how to run each (and how to verify them), step by step.

---

## 🧭 Step-by-Step: Running Your Ansible Cluster Playbooks

### **1. SSH into your remote Linux host**

From your Windows laptop:

```powershell
ssh user@<remote_host_ip>
```

---

### **2. Navigate to your Ansible project**

```bash
cd ~/path/to/your/ansible/files
```

You should see:

```
docker-swarm.yml
k8s-cluster.yml
inventory.ini
roles/
```

---

### **3. Check your inventory file**

Make sure you have an inventory file that defines your hosts. For example:

#### 🗂️ `inventory.ini`

```ini
[managers]
manager1 ansible_host=192.168.1.10 ansible_user=ec2-user

[workers]
worker1 ansible_host=192.168.1.11 ansible_user=ec2-user
worker2 ansible_host=192.168.1.12 ansible_user=ec2-user

[k8s_master]
master1 ansible_host=192.168.1.10 ansible_user=ec2-user

[k8s_workers]
worker1 ansible_host=192.168.1.11 ansible_user=ec2-user
worker2 ansible_host=192.168.1.12 ansible_user=ec2-user
```

Make sure SSH access works:

```bash
ansible all -i inventory.ini -m ping
```

You should see `pong` responses.

---

### **4. Run the Docker Swarm playbook first**

If you want to bring up your **Docker cluster**:

```bash
ansible-playbook -i inventory.ini docker-swarm.yml
```

This typically:

* Installs Docker
* Initializes the Swarm manager
* Joins workers to the Swarm
* Verifies the cluster status

To verify afterward:

```bash
docker node ls
```

You should see your manager and worker nodes listed.

---

### **5. Run the Kubernetes playbook**

Once Docker is verified and working, you can move on to Kubernetes:

```bash
ansible-playbook -i inventory.ini k8s-cluster.yml
```

This usually:

* Installs container runtime (Docker or containerd)
* Installs kubeadm, kubelet, and kubectl
* Initializes the master node
* Joins workers to the cluster

To verify afterward:

```bash
kubectl get nodes
```

You should see all your nodes in the `Ready` state.

---

### **6. Optional: Dry runs**

To preview without making changes:

```bash
ansible-playbook -i inventory.ini docker-swarm.yml --check
ansible-playbook -i inventory.ini k8s-cluster.yml --check
```

---

### **7. Optional: Limit to one host or group**

To run only on a specific group:

```bash
ansible-playbook -i inventory.ini k8s-cluster.yml --limit k8s_master
```

Or a specific host:

```bash
ansible-playbook -i inventory.ini k8s-cluster.yml --limit worker1
```

---

### ✅ **Summary**

| Purpose                     | File                                   | Verify with         |
| --------------------------- | -------------------------------------- | ------------------- |
| Create Docker Swarm cluster | `docker-swarm.yml`                     | `docker node ls`    |
| Create Kubernetes cluster   | `k8s-cluster.yml`                      | `kubectl get nodes` |
| Test connectivity           | `ansible all -i inventory.ini -m ping` | `pong` replies      |

---

Would you like me to **review both of your YAML files** (`docker-swarm.yml` and `k8s-cluster.yml`) to make sure they’re using the right modules and won’t conflict when you run them? That’s a good check before you deploy.
