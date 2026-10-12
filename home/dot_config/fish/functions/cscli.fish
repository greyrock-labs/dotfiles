function cscli --description 'Run cscli on the home-ops CrowdSec LAPI'
  command kubectl -n security exec deploy/crowdsec-lapi -c crowdsec-lapi -- cscli $argv
end
