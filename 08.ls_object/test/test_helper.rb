# frozen_string_literal: true

module TestHelper
  TARGET_PATHNAME = Pathname('test/fixtures')
  def prepare_variable_stats
    segment = 'variable_stats'
    dir_path = TARGET_PATHNAME.join(segment)
    prepare_files('variable_stats', segment, 5, 't')

    # データサイズ確認用Gemfileコピー
    file = TARGET_PATHNAME.join("#{segment}/Gemfile")
    FileUtils.cp_r(TARGET_PATHNAME.join('../../Gemfile'), file) unless File.exist?(file)

    # データタイプ確認用Directory
    dir = TARGET_PATHNAME.join("#{segment}/dir")
    Dir.mkdir(dir) unless Dir.exist?(dir)
    [segment, dir_path]
  end

  def prepare_files(dir, target = nil, loop_num = 10, sample = 'test')
    return if Dir.exist?(TARGET_PATHNAME.join(dir))

    Dir.mkdir(TARGET_PATHNAME.join(dir))
    loop_num.times do |i|
      File.open(TARGET_PATHNAME.join("#{dir}/#{sample}#{i}"), 'w')
    end
    File.open(TARGET_PATHNAME.join("#{dir}/#{target}"), 'w') unless target.nil?
  end
end
