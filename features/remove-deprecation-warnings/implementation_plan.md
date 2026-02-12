# Implementation Plan: remove-deprecation-warnings

## Task Format

Tasks should follow this format:
```
- [ ] [T001] Task description
      depends: T000 (optional, comma-separated)
      notes: Additional context (optional)
```

## TODO

## DONE

- [x] [T006] Verify no remaining deprecation warnings
      Ran `rails runner "puts 'ok'"` and `rspec spec/models/user_spec.rb spec/models/task_spec.rb
      spec/models/contract_spec.rb` checking stderr for deprecation warnings.
      Only remaining deprecation: `ActiveSupport::ProxyObject is deprecated` (3 occurrences) —
      comes from a third-party gem during `Bundler.require`, not from app code. Per spec, not fixing.
      Also present: `LOCALE_MATCHER` constant re-initialization warning in routes.rb — this is a
      regular Ruby warning, not a Rails deprecation. Per spec non-goals, not fixing.
      All app-code deprecation warnings (enum syntax, config options, Rack::Attack) are resolved.

- [x] [T005] Fix deprecated Rack::Attack response methods
      Changed `self.throttled_response` to `self.throttled_responder` in config/initializers/rack_attack.rb.
      Changed `self.blocklisted_response` to `self.blocklisted_responder`.
      New API takes a single `request` (Rack::Request) argument instead of `env` (Hash).
      Updated lambda bodies to access env via `request.env[...]` instead of `env[...]`.
      No more Rack::Attack deprecation warnings on boot. 12/13 rack_attack specs pass;
      1 pre-existing failure (asset path 404 due to missing webpack manifest, unrelated).
      RuboCop blocked by permissions.

- [x] [T004] Remove deprecated config options in config/application.rb
      Removed `ActiveSupport.to_time_preserves_timezone = false` from config/application.rb (line 37).
      Removed `config.active_job.use_big_decimal_serializer = true` from config/application.rb (line 97-98)
      and from components/domain/lib/domain/engine.rb (line 21-22).
      Both are defaults in Rails 7.2+ with `load_defaults 7.2`. App boots without these deprecation warnings.
      All tests pass (21 examples, 0 failures). RuboCop blocked by permissions.

- [x] [T003] Fix enum keyword argument syntax in components/subscriptions/ and components/payment_processing/
      Updated 8 enums across 3 files to use positional argument syntax.
      Files: pro_subscription_relation.rb (3 enums), subscription_relation.rb (4 enums),
      legacy_subscription_payment_relation.rb (1 enum). Options like `_scopes` changed to `scopes`.
      All tests pass (30 subscription + 8 payment_processing examples, 0 failures).
      No more enum deprecation warnings from subscriptions/payment_processing.
      RuboCop blocked by permissions.

- [x] [T001] Fix enum keyword argument syntax in app/models/
      Updated 13 enums across 10 files to use positional argument syntax.
      All tests pass (68 examples, 0 failures). No more enum deprecation warnings from app/models/.

- [x] [T002] Fix enum keyword argument syntax in components/domain/
      Updated 26 enums across 13 relation files to use positional argument syntax.
      Also updated the custom `enum` method in ActiveRecordAdapter to support the new
      positional argument syntax (`def enum(name = nil, values = nil, **options)`).
      All non-factory-dependent tests pass (56 examples, 0 failures across 4 specs).
      Pre-existing factory registration failures unrelated to enum changes.
      No enum deprecation warnings from domain files.

## FAILED
