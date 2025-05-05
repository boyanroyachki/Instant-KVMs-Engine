import getpass

def prompt_input(prompt_text, cast_func=str, default=None):
    while True:
        user_input = input(f"{prompt_text} [{default}]: ").strip()
        if not user_input and default is not None:
            return default
        try:
            return cast_func(user_input)
        except ValueError:
            print(f"Invalid input. Expected {cast_func.__name__}.")

def prompt_password():
    while True:
        pwd = getpass.getpass("Enter password: ")
        confirm = getpass.getpass("Confirm password: ")
        if pwd == confirm:
            return pwd
        print("Passwords do not match. Please try again.")

def main():

    # file_path = input("Enter the path to 'variables.tf': ")

    variables = {
        "hostname": prompt_input("Enter libvirt domain name", default="test"),
        "domain": prompt_input("Enter domain name", default="example.com"),
        "ip_type": prompt_input("Enter IP type (e.g., dhcp)", default="dhcp"),
        "size": prompt_input("Enter storage size in GB", int, default=40) * 1024 * 1024 * 1024,
        "memoryMB": prompt_input("Enter RAM size in MB", int, default=2048),
        "cpu": prompt_input("Enter number of CPUs", int, default=2),
        "user_name": prompt_input("Enter username", default="ubuntu"),
        "user_password": prompt_password(),
        "user_groups": prompt_input("Enter groups (comma-separated)", default="users,admin"),
        "image_name": prompt_input("Enter path to image", default="tf/assets/noble-server-cloudimg-amd64.img"),
        "format": prompt_input("Enter image format", default="qcow2"),
    }

    with open("tf/variables.tf", "w") as tf_file:
        for var_name, value in variables.items():
            tf_file.write(f'variable "{var_name}" {{\n')
            if isinstance(value, int):
                tf_file.write(f"  default = {value}\n")
            else:
                tf_file.write(f'  default = "{value}"\n')
            tf_file.write("}\n\n")

    # print(f"{file_path} has been generated successfully.")

if __name__ == "__main__":
    main()
