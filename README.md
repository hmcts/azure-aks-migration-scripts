# azure-aks-migration-scripts
Scripts to help in the AKS migration

## DNS switch over 

To run these scripts you will need network connectivity to the consul servers for the environment you are switching over, (Currently supported environments are `aat` and `prod`).

You will need to be on the VPN,
and either on `bastion.reform` or using `sshuttle -r bastion.reform 10.0.0.0/8` for the network access.

### dns-switch-back-to-ase.sh
In the unlikely event that we need to switch back to the ASE you can run this script to do it.
```bash
./dns-switch-back-to-ase.sh plum-recipes-service prod
```

### dns-switch-to-aks.sh
If you want to do a quick DNS switch you can use this script, or accidentally change the wrong app to ASE you can use this script:
```bash
./dns-switch-to-aks.sh plum-recipes-service prod
```