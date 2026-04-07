require "csv"

namespace :seed do
  desc "Import all KILO reference data from CSV files in db/seed_data/"
  task from_csv: :environment do
    seed_dir = Rails.root.join("db/seed_data")

    # Order matters: exercises before pairings, etc.
    import_order = %w[
      kilo_rep_intensity_tables
      kilo_exercises
      kilo_exercise_pairings
      kilo_optimal_ratios
      kilo_periodization_models
      kilo_rep_schemes
      kilo_training_splits
      kilo_macrocycle_templates
      kilo_training_methods
    ]

    import_order.each do |table_name|
      file = seed_dir.join("#{table_name}.csv")
      next unless file.exist?

      model_class = table_name.classify.constantize
      rows = CSV.read(file, headers: true, header_converters: :symbol)

      puts "Seeding #{table_name}: #{rows.count} rows..."

      rows.each do |row|
        attrs = row.to_h.compact.reject { |_, v| v.to_s.strip.empty? }
        # Find unique key for upsert based on table
        record = case table_name
        when "kilo_rep_intensity_tables"
          model_class.find_or_initialize_by(reps: attrs[:reps])
        when "kilo_exercises"
          model_class.find_or_initialize_by(name: attrs[:name])
        when "kilo_optimal_ratios"
          model_class.find_or_initialize_by(exercise: attrs[:exercise])
        when "kilo_periodization_models"
          model_class.find_or_initialize_by(
            model_id: attrs[:model_id],
            macrocycle_number: attrs[:macrocycle_number],
            phase: attrs[:phase]
          )
        when "kilo_training_methods"
          model_class.find_or_initialize_by(name: attrs[:name])
        when "kilo_training_splits"
          model_class.find_or_initialize_by(
            goal: attrs[:goal],
            phase: attrs[:phase],
            training_level: attrs[:training_level],
            frequency: attrs[:frequency],
            name: attrs[:name]
          )
        else
          model_class.new
        end

        record.assign_attributes(attrs)

        unless record.save
          puts "  ERROR: #{table_name} row #{row.to_h}: #{record.errors.full_messages.join(', ')}"
        end
      end

      puts "  Done. #{model_class.count} total records."
    end

    puts "\nSeed complete."
  end
end
