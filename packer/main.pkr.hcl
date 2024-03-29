source "azure-arm" "monitor" {
  # App info
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  subscription_id = "${var.subscription_id}"
  tenant_id       = "${var.tenant_id}"

  # Managed Image info
  managed_image_resource_group_name = "${var.managed_image_resource_group_name}"
  managed_image_name                = "${var.managed_image_name}"
  
  # Base Image info
  location        = "${var.location}"
  image_offer     = "${var.offer}"
  image_publisher = "${var.publisher}"
  image_sku       = "${var.sku}"
  os_type         = "${var.os_type}"
  vm_size         = "${var.size}"
  ssh_username    = "${var.ssh_username}"
}

build {
  sources = ["source.azure-arm.monitor"]
  
  # Copy Script
  provisioner "file" {
    source = "software.sh"
    destination = "/tmp/software.sh"
  }
  # Copy Ansible workspace
  provisioner "file" {
    source = "../ansible"
    destination = "/tmp/"
  }

  # Copy ansible workspace and Excute Script
  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline_shebang  = "/bin/bssh -x"
    inline = [
      "cp -r /tmp/ansible /opt/",
      "chmod +x /tmp/software.sh",
      "/tmp/software.sh ${var.influxdb_name} ${var.influxdb_username} ${var.influxdb_password}"
    ]
  }

  # 이미지 생성을 위한 Azure VM 에이전트+사용자 삭제
  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline_shebang  = "/bin/sh -x"
    inline = [
      "/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"
    ]
  }
}