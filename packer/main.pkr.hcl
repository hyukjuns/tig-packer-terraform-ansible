source "azure-arm" "monitor" {
  # 앱정보
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  subscription_id = "${var.subscription_id}"
  tenant_id       = "${var.tenant_id}"

  # 이미지 만들때 사용될 Base Image
  location        = "${var.location}"
  image_offer     = "${var.offer}"
  image_publisher = "${var.publisher}"
  image_sku       = "${var.sku}"
  os_type         = "${var.os_type}"
  vm_size         = "${var.size}"
  ssh_username    = "azureuser"

  # 앞으로 생성될 정보
  managed_image_resource_group_name = "${var.managed_image_resource_group_name}"
  managed_image_name                = "${var.managed_image_name}"

  # 태그
  azure_tags = {
    version = "${var.image_version}"
  }
}

build {
  sources = ["source.azure-arm.monitor"]
  # Grafana 설치
  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline_shebang  = "/bin/sh -x"
    inline = [
      "sudo apt-get install -y apt-transport-https",
      "sudo apt-get install -y software-properties-common wget",
      "sudo wget -q -O /usr/share/keyrings/grafana.key https://packages.grafana.com/gpg.key",
      "echo \"deb [signed-by=/usr/share/keyrings/grafana.key] https://packages.grafana.com/oss/deb stable main\" | sudo tee -a /etc/apt/sources.list.d/grafana.list",
      "sudo apt-get update -y",
      "sudo apt-get install -y grafana",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable --now grafana-server.service"
    ]
  }
  # InfluxDB 설치 및 설정파일 셋업
  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline_shebang  = "/bin/sh -x"
    inline = [
      "wget -q https://repos.influxdata.com/influxdb.key",
      "echo '23a1c8836f0afc5ed24e0486339d7cc8f6790b83886c4c96995b88a061c5bb5d influxdb.key' | sha256sum -c && cat influxdb.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/influxdb.gpg > /dev/null",
      "echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdb.gpg] https://repos.influxdata.com/debian stable main' | sudo tee /etc/apt/sources.list.d/influxdata.list",
      "sudo apt-get update -y && sudo apt-get install -y influxdb",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable --now influxdb",
      "curl \"http://localhost:8086/query\" --data-urlencode \"q=CREATE DATABASE \"${var.influxdb_db_name}\"\"",
      "curl \"http://localhost:8086/query\" --data-urlencode \"q=CREATE USER ${var.influxdb_user_name} WITH PASSWORD '${var.influxdb_user_password}' WITH ALL PRIVILEGES\"",
      "curl \"http://localhost:8086/query\" --data-urlencode \"q=GRANT ALL PRIVILEGES TO \"${var.influxdb_user_name}\"\"",
      "sed -i \"s/# auth-enabled = false/auth-enabled = true/g\" /etc/influxdb/influxdb.conf"
    ]
  }

  # Ansible 설치, Telegraf 설정파일 셋업
  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline_shebang  = "/bin/sh -x"
    inline = [
      "sudo apt update -y",
      "sudo apt install -y software-properties-common",
      "sudo add-apt-repository --yes --update ppa:ansible/ansible",
      "sudo apt install -y ansible"
    ]
  }

  # Make Ansbile workspace
  provisioner "file" {
    source      = "../ansible"
    destination = "/tmp"
  }
  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline_shebang  = "/bin/sh -x"
    inline = [
      "perl -i -pe 's/DB_NAME/${var.influxdb_db_name}/g' /tmp/ansible/config/telegraf.conf",
      "perl -i -pe 's/DB_ADMIN_NAME/${var.influxdb_user_name}/g' /tmp/ansible/config/telegraf.conf",
      "perl -i -pe 's/DB_ADMIN_PASSWORD/${var.influxdb_user_password}/g' /tmp/ansible/config/telegraf.conf"
    ]
  }
  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline_shebang  = "/bin/sh -x"
    inline = [
      "sudo mv /tmp/ansible /opt"
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