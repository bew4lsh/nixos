{ config, pkgs, ... }:

{
  # Docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;

    # Use Docker rootless for better security (optional)
    # rootless = {
    #   enable = true;
    #   setSocketVariable = true;
    # };

    # Automatic cleanup
    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = [ "--all" ];
    };
  };

  # Add user to docker group (merged with other groups in host config)
  # users.users.lia.extraGroups defined in hosts/adrasteia/default.nix

  # Container tools
  environment.systemPackages = with pkgs; [
    # Docker
    docker-compose
    docker-buildx
    lazydocker  # TUI for Docker

    # Kubernetes
    kubectl
    kubernetes-helm
    helmfile
    k9s           # TUI for Kubernetes
    kubectx       # Switch contexts/namespaces
    stern         # Multi-pod log tailing
    kustomize

    # Container security
    trivy         # Vulnerability scanner

    # Container utilities
    dive          # Explore Docker layers
    skopeo        # Container image operations
    crane         # Container registry tool
  ];

  # Kubectl completion and aliases
  programs.bash.interactiveShellInit = ''
    # Kubectl completion
    source <(kubectl completion bash 2>/dev/null)
    # Kubectl aliases
    alias k='kubectl'
    alias kgp='kubectl get pods'
    alias kgs='kubectl get services'
    alias kgd='kubectl get deployments'
    alias kga='kubectl get all'
    alias kaf='kubectl apply -f'
    alias kdel='kubectl delete'
    alias klog='kubectl logs'
    alias kexec='kubectl exec -it'
  '';
}
