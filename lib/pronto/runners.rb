module Pronto
  class Runners
    def initialize(runners = Runner.runners, config = Config.new)
      @runners = runners
      @config = config
    end

    def run(patches)
      patches = reject_excluded(@config.excluded_files('all'), patches)
      return [] if patches.none?

      result = []
      @runners.each do |runner|
        next if exceeds_max?(result)
        @config.logger.log("Running #{runner}")
        runner_patches = reject_excluded(
          @config.excluded_files(runner.title), patches
        )
        next if runner_patches.none?
        result += run_runner(runner, patches)
      end
      result = result.take(@config.max_warnings) if @config.max_warnings
      result
    end

    private

    def run_runner(runner, patches)
      override_level = @config.override_level(runner.title)
      runner.new(patches, patches.commit).run.flatten.compact.each do |msg|
        msg.level = override_level.to_sym if override_level
      end
    end

    def reject_excluded(excluded_files, patches)
      return patches unless excluded_files.any?

      patches.reject do |patch|
        excluded_files.include?(patch.new_file_full_path.to_s)
      end
    end

    def exceeds_max?(warnings)
      @config.max_warnings && warnings.count >= @config.max_warnings
    end
  end
end
