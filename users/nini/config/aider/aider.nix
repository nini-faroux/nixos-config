{ ... }:

{
  home.file.".aider.conf.yml".text = ''
    # Keep global defaults here
    openai-api-base: http://127.0.0.1:8080/v1
    openai-api-key: local-proxy-token
    
    # Behavior
    architect: true
    no-check-model-accepts-settings: true
    stream: true
  '';
}
