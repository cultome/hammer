
module Hammer::Detector
  def detect_format(filename)
    fragment = File.new(filename).read(100)

    detector_methods = methods.grep(/^is_(\w+?)_format\?$/)
    format = detector_methods.find{|mtd| send(mtd, fragment) }

    raise "unrecognized format" if format.nil?

    format =~ /^is_(\w+?)_format\?$/ && $1.to_sym
  end

  def is_csv_format?(fragment)
    fragment.start_with?(/[\w]/) && fragment.count(",") > 5
  end
end
