# v5.1.0 - 2022-02-15

Updated
  * AZ-676: Bump Ansible-Playbook `claranet-cloud-image` to `v0.2.1` 

# v5.0.0 - 2022-01-13

Breaking
  * AZ-515: Option to use Azure CAF naming provider to name resources
  * AZ-515: Require Terraform 0.13+, bump AzureRM provider to `v2.83` minimum to match `linux-vm` module requirements

# v4.3.1 - 2021-12-21

Fixed
  * AZ-607: Update example usage and wait until the bastion VM is reachable before executing the Ansible playbook

# v4.3.0 - 2021-10-19

Breaking
  * AZ-492: Refactor SSH keys management

Added
  * AZ-561: Allow to deploy Bastion vm without public IP

Changed
  * AZ-572: Revamp examples and improve CI

# v4.2.0 - 2021-08-20

Updated
  * AZ-532: Revamp README with latest `terraform-docs` tool
  * AZ-530: Cleanup module, fix linter errors
  * AZ-530: Bump submodule `linux-vm` to `v4.1.2`

# v4.1.0 - 2020-12-15

Changed
  * AZ-398: Force lowercases on default generated name

# v3.1.3/v4.0.0 - 2020-12-11

Updated
  * AZ-273: Module now compatible terraform `v0.13+`
  * AZ-273: Bump `linux-vm` module to `v4.0.0` and output VM System assigned identity

Fixed
  * AZ-324: Allow use of `storage_os_disk_custom_name` variable

# v3.1.2 - 2020-11-18

Fixed
  * AZ-321: Allow use of specific tags for public IP and Network Interface

# v3.1.1 - 2020-09-28

Fixed
  * AZ-301: README update of the 'network-security-group' module example (`custom_name` handling)

# v3.1.0 - 2020-07-30

Breaking
  * AZ-236: Use the generic `linux-vm` module (many resources name changes)

# v2.2.1 / v3.0.0 - 2020-07-09

Changed
  * AZ-209: Update CI with Gitlab template
  * AZ-142: Adding LICENSE / CONTRIBUTING + update README

# v2.2.0 - 2020-03-25

Added
  * AZ-112: Add custom resources names
    - Custom name for NIC
    - Custom name for NIC Ipconfiguration
    - Custom name for Public IP

# v2.1.1 - 2020-02-14

Changed
  * AZ-168: Refactoring and fixes
    - Add ansible galaxy `--force` option to fetch the right roles version
    - Private IP is mandatory when set to static
    - Revamp README usage example

# v2.1.0 - 2020-01-31

Changed
  * AZ-168: Refactoring and fixes, also new outputs

# v2.0.2 - 2020-01-27

Changed
  * AN-77: Use Ansible cloud image role tag version

# v2.0.1 - 2019-12-30

Changed
  * AZ-164: Fix warning from public IP allocation method

# v2.0.0 - 2019-10-16

Breaking
  * AZ-94: Terraform 0.12 / HCL2 format

# v0.2.0 - 2019-07-01

Changed
  * AZ-49: Normalize variables and files, also fix minor issues

# v0.1.0 - 2019-04-24

Changed
  * AZ-6: Uses latest `azure-region` module convention (location)
  * AZ-3: Gitlab CI and tests
  * TER-344: Allow custom tags on every bastion resources
  * TER-318: Allow custom admin IPs addresses
  * TER-237: Major module updates with better resources naming.
  * TER-209: Add CI tests.

# v0.0.1 - 2019-01-04

Added
  * TER-14: First Release.
