# Fact: diskinfo_blockdev_model_to_hctl
#
# Purpose: Return hash mapping block device model name to array/list of SCSI HCTLs
#
# Resolution: Uses lsblk to gather data
#
# Caveats:
#

lsblk = Puppet::Util::Execution.execute('lsblk -o model,hctl').split(/\n/).select { |x| not x.start_with? 'MODEL' and x.strip.length > 0 }
model_to_hctl = {}

lsblk.each do |i|

  i =~ /^(.*[^\s])\s*(\d+:\d+:\d+:\d+)$/
  model = $1
  hctl = $2

  if(!model_to_hctl.key?(model))
    model_to_hctl[model] = []
  end

  if(!model_to_hctl[model].include?(hctl))
    model_to_hctl[model].push(hctl)
  end

end

Facter.add("diskinfo_blockdev_model_to_hctl") do
  setcode do
    model_to_hctl
  end
end

# vim:ts=2 sts=2 sw=2 et
