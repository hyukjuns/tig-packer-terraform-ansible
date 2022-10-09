 import winrm

 s = winrm.Session('windows:5985', auth=('user', 'password'))
 r = s.run_cmd('ipconfig', ['/all'])

 print(r.status_code)
 print(r.std_out.splitlines(True))