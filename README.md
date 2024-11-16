Welcome to t3rn, a Modular Interoperability Layer designed for fast, secure, and cost-efficient cross-chain swapping. t3rn is uniquely positioned to bridge the gaps in blockchain interoperability, offering superior swapping for users and yield for infra providers by becoming t3rn Executors. <br>
Docs : [t3rn docs](https://docs.t3rn.io/intro) | X : [t3rn](https://x.com/t3rn_io)

## t3rn Executor Setup Guide

This guide provides a method to install the `t3rn` executor as a systemd service, ensuring more reliable operation compared to using `screen`

---

## Installation Steps

### Step 1: Clone the Repository
Run the following command on your server to clone the repository:

```
git clone https://github.com/AlexSHuk/t3rn_executor.git
```

### Step 2: Modify the Service Template
Navigate to the cloned directory and edit the `t3rn-executor.service.template` file to add your private key:
```
cd t3rn_executor
nano t3rn-executor.service.template
```
In the template file, locate the line containing <replace_your_privatekey> and replace it with your actual private key.

### Step 3: Make the Scripts Executable
Set the required scripts as executable:
```
sudo chmod +x install_executor.sh
sudo chmod +x update_executor.sh
```

### Step 4: Install the Executor
Run the installation script:
```
./install_executor.sh
```
This script will download the latest version of the t3rn executor, set up the systemd service, and start it.

### Optional: Update the Executor
To update the executor to the latest version, run the update script:
```
./update_executor.sh
```
This script will download the latest version and restart the service to apply the updates.


By following this guide, the t3rn executor will run as a systemd service, providing stable and efficient operation
