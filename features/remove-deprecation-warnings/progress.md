# Progress: remove-deprecation-warnings

## Log

<!-- Each iteration appends a summary here -->
<!-- Format: [YYYY-MM-DD HH:MM] Task ID - Summary -->

[2026-02-06] T001 - Fixed enum keyword argument syntax in app/models/. Updated 13 enums across 10 files from `enum name: { ... }` to `enum :name, { ... }`. Options like `_scopes` changed to `scopes`. Files: place.rb, task_report.rb, listworker.rb, support_agent_provider.rb, sem_text.rb, support_agent.rb, comment_report.rb, sem_text/translation.rb, notification.rb, pro.rb. All tests pass (68 examples, 0 failures). RuboCop check was blocked by permissions.

[2026-02-06] T002 - Fixed enum keyword argument syntax in components/domain/. Updated 26 enums across 13 relation files. Also updated ActiveRecordAdapter.enum to support new positional argument syntax (was only accepting keyword hash). Files: transactional_relation.rb (2), service_offer_relation.rb (3), service_relation.rb (3), cancellation_relation.rb (1), service_provider_card_relation.rb (1), service_request_relation.rb (5), service_history_relation.rb (2), report_relation.rb (1), legacy_payment_relation.rb (1), consent_relation.rb (2), user_relation.rb (3), service_provider_relation.rb (2), recurrence_relation.rb (1). Also updated: active_record_adapter.rb. All non-factory-dependent tests pass (56 examples, 0 failures). RuboCop blocked by permissions.

[2026-02-06] T004 - Removed deprecated config options. Deleted `ActiveSupport.to_time_preserves_timezone = false` from config/application.rb and `config.active_job.use_big_decimal_serializer = true` from config/application.rb and components/domain/lib/domain/engine.rb. Both are defaults in Rails 7.2+ with load_defaults 7.2. All tests pass. RuboCop blocked by permissions.

[2026-02-06] T005 - Fixed deprecated Rack::Attack response methods. Changed `throttled_response` to `throttled_responder` and `blocklisted_response` to `blocklisted_responder` in config/initializers/rack_attack.rb. New API takes a Rack::Request object instead of raw env hash. Updated lambda bodies accordingly. 12/13 rack_attack specs pass (1 pre-existing failure unrelated to change). RuboCop blocked by permissions.

[2026-02-06] T006 - Verified no remaining app-code deprecation warnings. Only remaining: `ActiveSupport::ProxyObject` from third-party gem (not app code, per spec not fixing). All T001-T005 deprecation warnings confirmed resolved. Feature complete.
