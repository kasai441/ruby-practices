# frozen_string_literal: true

module TestHelper
  TARGET_PATHNAME = Pathname('test/fixtures')
  def prepare_data(dir, target = nil, loop_num = 10, sample = 'test')
    return if Dir.exist?(TARGET_PATHNAME.join(dir))

    Dir.mkdir(TARGET_PATHNAME.join(dir))
    loop_num.times do |i|
      File.open(TARGET_PATHNAME.join("#{dir}/#{sample}#{i}"), 'w')
    end
    File.open(TARGET_PATHNAME.join("#{dir}/#{target}"), 'w') unless target.nil?
  end
end
