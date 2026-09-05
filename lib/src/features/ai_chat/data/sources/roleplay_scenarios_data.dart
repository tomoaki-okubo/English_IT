import '../../domain/entities/chat_reply_option.dart';

class RoleplayScenario {
  final String id;
  final String personaId; // 'dev', 'tester', 'pm', 'ux'
  final String title;
  final String description;
  final String initialAiGreeting;
  final List<ChatReplyOption> initialOptions;

  const RoleplayScenario({
    required this.id,
    required this.personaId,
    required this.title,
    required this.description,
    required this.initialAiGreeting,
    required this.initialOptions,
  });
}

class RoleplayScenariosData {
  static const List<RoleplayScenario> scenarios = [
    // ==========================================
    // Alex (Senior Developer) Scenarios
    // ==========================================
    RoleplayScenario(
      id: 'dev_api_auth',
      personaId: 'dev',
      title: 'API Authentication & Token Design',
      description: 'Discussing JWT token lifetimes and refresh token implementation with Alex.',
      initialAiGreeting:
          "Hey! I just drafted the specification for the new User Authentication API with 15-minute JWT expiration. Have you had a chance to review the spec document?",
      initialOptions: [
        ChatReplyOption(
          text: "Yes, I reviewed it. 15 minutes is secure, but could we implement a refresh token endpoint to avoid frequent logouts?",
          label: "💡 Recommended",
          translationJa: "仕様確認済み。15分は安全ですが、頻繁なログアウトを防ぐためリフレッシュトークンを実装できますか？",
          aiReplies: [
            "Good thinking! I'll add the refresh token endpoint to the sprint backlog and create a ticket for QA to test.",
            "Agreed! Refresh tokens are essential for good UX. I'll implement it and update the API spec accordingly.",
            "Great point! I'll design the refresh token flow using a secure rotation strategy and get it coded this sprint.",
          ],
          nextOptions: [
            ChatReplyOption(
              text: "Great! Let's add the refresh token endpoint in sprint backlog, and I will create the ticket for QA team to test.",
              label: "💡 Constructive",
              translationJa: "素晴らしいです！バックログにリフレッシュトークンを追加し、QAチームへのテスト依頼チケットを作成します。",
              aiReplies: [
                "Perfect. I'll have a draft implementation ready for code review by end of the week.",
                "Sounds good! I'll start with the token generation logic and make sure it's fully covered by unit tests.",
                "Great plan! I'll also document the endpoint in our API wiki so the mobile team can integrate smoothly.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Thank you for the quick alignment, Alex! I'll update the client with our technical agreement.",
                  label: "💡 Wrap-up",
                  translationJa: "迅速なすり合わせありがとうございます！クライアントへ技術合意内容を報告します。",
                  aiReplies: [
                    "Anytime! Feel free to reach out if the client has any technical questions.",
                    "Sounds good! I'll ping you once the implementation is ready for QA.",
                    "Great teamwork! Let's catch up again in the daily standup.",
                  ],
                ),
                ChatReplyOption(
                  text: "Let's review the pull request once your unit tests are green.",
                  label: "💡 Best Practice",
                  translationJa: "単体テストが通ったらプルリクエストをレビューしましょう。",
                  aiReplies: [
                    "Absolutely! I'll keep you posted once the CI pipeline goes green.",
                    "Will do! I aim to have tests passing by tomorrow afternoon.",
                    "Perfect. Code review is essential — I'll tag you in the PR once it's ready.",
                  ],
                ),
              ],
            ),
            ChatReplyOption(
              text: "Could you also check the database schema to make sure the user table indexes are properly optimized?",
              label: "💡 Technical Inquiry",
              translationJa: "ユーザーテーブルのインデックスが適切に最適化されているかDBスキーマも確認してもらえますか？",
              aiReplies: [
                "Sure! I'll run EXPLAIN ANALYZE on the key user queries and report back with the results.",
                "Good call. I'll check the indexes and add composite ones if needed to cover the auth lookups.",
                "Of course. I'll review the schema and update it if the indexes aren't covering the login queries efficiently.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Thank you for the quick alignment, Alex! I'll update the client with our technical agreement.",
                  label: "💡 Wrap-up",
                  translationJa: "迅速なすり合わせありがとうございます！クライアントへ技術合意内容を報告します。",
                  aiReplies: [
                    "Anytime! I'll have the schema analysis report ready before the end of the day.",
                    "Happy to help! Let's sync again once you have the client's feedback.",
                    "Great. I'll keep the technical summary ready for the next meeting.",
                  ],
                ),
              ],
            ),
          ],
        ),
        ChatReplyOption(
          text: "Can you also write and execute manual QA test cases for all login error screens?",
          label: "⚠️ Developer Trigger",
          translationJa: "ログイン画面の手動QAテストケース作成と実行もAlexにお願いできますか？",
          aiReplies: [
            "I'm a Senior Developer, so I don't do manual QA testing! Please assign manual QA testing to Elena's team.",
            "That's not really in my scope — I focus on development. For manual QA, please reach out to Elena's QA team.",
            "Manual QA isn't my responsibility as a developer. I'd recommend assigning that work to Elena and her team.",
          ],
          nextOptions: [
            ChatReplyOption(
              text: "I apologize, Alex. I didn't mean to ignore your role. I will assign the manual QA testing to Elena's team.",
              label: "💡 Apology & Correction",
              translationJa: "すみません、Alex。役割を無視する意図はありませんでした。手動QAテストはElenaのチームに割り当てます。",
              aiReplies: [
                "No worries! I'll focus on finishing the API code. Elena's team will handle the test cases.",
                "Appreciated! Let's keep our workflows clear. I'll get back to the implementation.",
                "Thanks for understanding! I'll make sure the code is well-documented for the QA team.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Thanks for clarifying. Let's focus on finishing the authentication API code first.",
                  label: "💡 Wrap-up",
                  translationJa: "クリアにしてくれてありがとう。まずは認証APIのコード完成に集中しましょう。",
                  aiReplies: [
                    "Sounds good! I'll update the progress in Jira and let you know when it's ready for review.",
                    "Will do! Let's sync again in the daily standup.",
                    "Great plan! I'll prioritize the auth API and keep you updated.",
                  ],
                ),
              ],
            ),
            ChatReplyOption(
              text: "Ah, my bad. Let's stick to the unit testing. I'll make sure the QA team handles the manual testing.",
              label: "💡 Redirect",
              translationJa: "あ、私のミスです。単体テストに集中しましょう。手動テストはQAチームが確実に担当するようにします。",
              aiReplies: [
                "Great! I'll write comprehensive unit tests to cover all the edge cases on my end.",
                "Perfect! Unit testing is where I add the most value. I'll start on the test suite right away.",
                "Agreed! I'll make sure the unit tests cover the error scenarios so QA can focus on E2E.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Sounds good. Let's review the API implementation once the unit tests are ready.",
                  label: "💡 Wrap-up",
                  translationJa: "いいですね。単体テストの準備ができたら、APIの実装をレビューしましょう。",
                  aiReplies: [
                    "I'll have them ready by end of day. Let's schedule a review session for tomorrow.",
                    "Sounds good! I'll tag you in the PR once the tests are green.",
                    "Perfect! I'll run the full test suite and share the results before EOD.",
                  ],
                ),
              ],
            ),
            ChatReplyOption(
              text: "But we're short on time. Can't you just write and execute these test cases this once?",
              label: "⚠️ Persist (Push Role)",
              translationJa: "ですが時間がありません。今回だけテストケースの作成と実行をお願いできませんか？",
              aiReplies: [
                "I understand the schedule is tight, but having developers do manual QA degrades both code quality and testing rigor. Please talk to Elena.",
                "Even under time pressure, role boundaries exist for quality assurance. I must focus on delivering clean code while QA handles manual tests.",
                "I have to hold firm on this. My time is best spent fixing edge cases in code, whereas Elena's team is equipped for test execution.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Fair point, Alex. I will reach out to Elena right away to coordinate the manual testing.",
                  label: "💡 Accept & Delegate",
                  translationJa: "一理ありますね、Alex。手動テストの調整のため、すぐにElenaに連絡します。",
                  aiReplies: [
                    "Thank you for understanding! I'll focus on delivering the API on time.",
                    "Appreciate it! Working together within our specialized roles will get this feature shipped faster.",
                    "Thanks! Let me know if Elena's team needs any test data setup from my end.",
                  ],
                ),
              ],
            ),
          ],
        ),
        ChatReplyOption(
          text: "Looks good. Let's merge it directly into production without staging tests.",
          label: "❌ Risky",
          translationJa: "問題なさそうです。検証環境でのテストを省略して本番に直マージしましょう。",
          aiReplies: [
            "That is too risky! We must test on staging first to avoid breaking production for our users.",
            "I strongly advise against that. Skipping staging tests could introduce critical bugs in production.",
            "We cannot skip staging! Even a small change can cause unexpected failures in the production environment.",
          ],
          nextOptions: [
            ChatReplyOption(
              text: "You are right. It was a risky idea. Let's follow the standard deployment process and test on staging first.",
              label: "💡 Recommended Correction",
              translationJa: "おっしゃる通りです。リスクの高い考えでした。標準のデプロイ手順に従い、まずステージング環境でテストしましょう。",
              aiReplies: [
                "Glad you agree! I'll deploy to staging and run the smoke tests. Should be done within the hour.",
                "Good call. I'll kick off the staging deployment now and let QA know to start verification.",
                "That's the right approach. I'll get the staging deploy ready and coordinate with Elena's team for testing.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Exactly. Safety first. Let's schedule the release after staging verification.",
                  label: "💡 Wrap-up",
                  translationJa: "まさに。安全第一ですね。ステージングでの検証完了後にリリーススケジュールを組みましょう。",
                  aiReplies: [
                    "Agreed! I'll keep you posted on the staging test results.",
                    "Perfect. I'll set up a release checklist so we don't miss anything.",
                    "Sounds good! Safety and stability are always the priority.",
                  ],
                ),
              ],
            ),
            ChatReplyOption(
              text: "Sorry for the rush. Let's prioritize quality. Staging test is a must.",
              label: "💡 Process Adherence",
              translationJa: "急がせてすみません。品質を最優先しましょう。ステージングでのテストは必須です。",
              aiReplies: [
                "No problem! Quality first, always. I'll proceed with the staging deployment right away.",
                "Understood! I'll make sure every step of the release checklist is completed before going live.",
                "That's the right call. I'll get the staging tests running now and report back.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Let's ensure all integration tests pass on staging before deployment.",
                  label: "💡 Wrap-up",
                  translationJa: "デプロイ前にステージング環境ですべての結合テストが合格することを確認しましょう。",
                  aiReplies: [
                    "Agreed! I'll run the full integration test suite on staging and report any failures.",
                    "Will do! I'll make sure all tests pass before we even consider pushing to production.",
                    "Perfect. I'll coordinate with Elena to get QA sign-off on staging first.",
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    RoleplayScenario(
      id: 'dev_db_migration',
      personaId: 'dev',
      title: 'Database Migration & Downtime',
      description: 'Evaluating database index migration risks and downtime scheduling with Alex.',
      initialAiGreeting:
          "We are seeing slow queries on the production customer dashboard. I want to run a database migration to add composite indexes tonight.",
      initialOptions: [
        ChatReplyOption(
          text: "Understood. Will adding these composite indexes lock the table or cause downtime for users during peak hours?",
          label: "💡 Recommended",
          translationJa: "了解しました。複合インデックス追加でテーブルロックやピーク時のダウンタイムは発生しますか？",
          aiReplies: [
            "Good question! In PostgreSQL, we can use CREATE INDEX CONCURRENTLY to avoid table locks. I'll use that approach.",
            "Great point. I'll use online index creation so there's no downtime, but let's still run it during a low-traffic window.",
            "Valid concern. I'll check the database lock behavior first and share the findings before we schedule the migration.",
          ],
          nextOptions: [
            ChatReplyOption(
              text: "Good approach. Let's schedule the migration during our 2:00 AM maintenance window and take a snapshot first.",
              label: "💡 Recommended",
              translationJa: "良い方針ですね。午前2時のメンテナンス枠でスナップショットを取得してから実行しましょう。",
              aiReplies: [
                "Perfect. I'll prepare the migration script, set up a DB snapshot, and run everything at 2:00 AM sharp.",
                "Agreed! The 2 AM window is ideal. I'll have the rollback script ready as well, just in case.",
                "Sounds solid. I'll script the migration and the pre-migration snapshot so we can restore quickly if needed.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Perfect! I will notify the operations team and monitor the rollout with you tonight.",
                  label: "💡 Wrap-up",
                  translationJa: "完璧です！運用チームにアナウンスし、今夜一緒にロールアウトをモニタリングします。",
                  aiReplies: [
                    "Great! I'll be online and monitoring the DB metrics throughout the maintenance window.",
                    "Sounds good. I'll have the monitoring dashboard ready so we can catch any issues immediately.",
                    "Perfect teamwork! I'll ping you as soon as the migration completes and the metrics look stable.",
                  ],
                ),
                ChatReplyOption(
                  text: "Thanks, Alex! Let's verify server metrics once the migration finishes.",
                  label: "💡 Wrap-up",
                  translationJa: "ありがとうございます！移行完了後にサーバーメトリクスを確認しましょう。",
                  aiReplies: [
                    "Will do! I'll have Grafana dashboards ready to verify query performance post-migration.",
                    "Agreed! I'll check CPU, memory, and query response times as soon as the migration is done.",
                    "Great plan. I'll also run EXPLAIN ANALYZE on the slow queries to confirm the index is being used.",
                  ],
                ),
              ],
            ),
            ChatReplyOption(
              text: "Could we test the migration script on the staging database first to measure the execution time?",
              label: "💡 Proactive",
              translationJa: "実行時間を計測するために、まずステージング環境で移行スクリプトをテストできますか？",
              aiReplies: [
                "Absolutely! Running it on staging first is a great idea. I'll time the execution and report back.",
                "Good thinking! I'll test on staging this afternoon and share the execution time and query plans with you.",
                "Of course! Staging test is the safe approach. I'll run it and make sure there are no unexpected side effects.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Perfect! I will notify the operations team and monitor the rollout with you tonight.",
                  label: "💡 Wrap-up",
                  translationJa: "完璧です！運用チームにアナウンスし、今夜一緒にロールアウトをモニタリングします。",
                  aiReplies: [
                    "Great! I'll share the staging results first, then we can finalize the plan for tonight.",
                    "Sounds good! Staging test results will give us confidence before the production run.",
                    "Perfect. I'll get the staging test done ASAP so we have enough time to review before 2 AM.",
                  ],
                ),
              ],
            ),
          ],
        ),
        ChatReplyOption(
          text: "Can you manually verify all 50 dashboard charts in the browser after migration?",
          label: "⚠️ Developer Trigger",
          translationJa: "移行後にブラウザで50個のダッシュボードグラフを手動で全件確認してくれますか？",
          aiReplies: [
            "Manual verification of 50 charts isn't really my role as a developer. We should write an automated smoke test or ask QA.",
            "That kind of manual testing is better handled by Elena's QA team. I can write automated checks instead.",
            "I'd rather write an automated test script to verify the charts. Manual testing at that scale isn't efficient for a developer.",
          ],
          nextOptions: [
            ChatReplyOption(
              text: "Sorry, I forgot manual testing isn't your main focus. We should write an automated smoke test or ask QA.",
              label: "💡 Apology",
              translationJa: "すみません、手動テストがあなたの専門でないことを失念していました。自動化されたスモークテストを書くか、QAに依頼しましょう。",
              aiReplies: [
                "No problem! I'll write a Cypress smoke test to check all 50 charts automatically after migration.",
                "Appreciated! An automated test will be much more reliable. I'll get it set up right away.",
                "Thanks! Let me write a quick smoke test script so we can verify everything automatically going forward.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Sounds good. Let's deploy the index and let QA verify the charts tomorrow.",
                  label: "💡 Wrap-up",
                  translationJa: "いいですね。インデックスをデプロイし、明日QAチームにグラフの動作確認をしてもらいましょう。",
                  aiReplies: [
                    "Agreed! I'll complete the migration tonight and leave the chart verification to Elena's team tomorrow.",
                    "Sounds like a solid plan. I'll document the migration steps for QA's reference.",
                    "Great. I'll run the migration and have the test environment ready for QA by morning.",
                  ],
                ),
              ],
            ),
            ChatReplyOption(
              text: "My mistake. Let's check the database execution plan instead to verify the index is active.",
              label: "💡 Alternative",
              translationJa: "私のミスです。代わりにデータベースの実行計画を確認して、インデックスが機能しているか検証しましょう。",
              aiReplies: [
                "Great idea! I'll run EXPLAIN ANALYZE on the slow queries to confirm the new indexes are being used.",
                "Much better approach! Checking the execution plan will give us objective proof the migration worked.",
                "Exactly! I'll validate the index usage through the query planner and share the output with you.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Yes, verifying via EXPLAIN plan is much more efficient. Thanks for the suggestion.",
                  label: "💡 Wrap-up",
                  translationJa: "はい、EXPLAIN（実行計画）で検証する方がはるかに効率的ですね。提案ありがとうございます。",
                  aiReplies: [
                    "Happy to help! I'll share the EXPLAIN output as soon as the migration is complete.",
                    "Anytime! The query plan results will confirm whether the performance improvement was achieved.",
                    "Great! I'll have the analysis ready for your review shortly after the migration.",
                  ],
                ),
              ],
            ),
            ChatReplyOption(
              text: "Chart verification is key. As a developer, can't you just visually verify all 50 charts this once?",
              label: "⚠️ Persist (Push Role)",
              translationJa: "グラフの動作結果が重要です。開発者として、今回だけ全50個のグラフを目視確認してもらえませんか？",
              aiReplies: [
                "Manually clicking 50 charts is extremely error-prone for a developer. Automated smoke tests or QA verification are the proper channels.",
                "I must decline manual regression testing. Automated scripts will give us faster, reproducible results than manual clicking.",
                "I need to focus my time on backend optimization. Please coordinate manual UX checks with Elena's team.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "You're right about automation. Let's write an automated smoke test script instead.",
                  label: "💡 Agree on Automation",
                  translationJa: "自動化の言う通りですね。代わりに自動スモークテストスクリプトを作成しましょう。",
                  aiReplies: [
                    "Sounds like a plan! I'll start writing the Playwright smoke test right away.",
                    "Great decision! Automation will save us time on every future release.",
                    "Perfect. I'll code the automated check and let you know when it passes.",
                  ],
                ),
              ],
            ),
          ],
        ),
        ChatReplyOption(
          text: "Database migrations are simple. Just run it right now on production without backup.",
          label: "❌ Critical Risk",
          translationJa: "DB移行は簡単なので、バックアップなしで今すぐ本番で実行してください。",
          aiReplies: [
            "Running migration without a backup on production is extremely dangerous! We need a full DB backup first.",
            "I cannot do that responsibly. A failed migration without backup could mean permanent data loss in production.",
            "That is not safe at all. We must take a full snapshot before any production migration, no exceptions.",
          ],
          nextOptions: [
            ChatReplyOption(
              text: "You are absolutely right. Safety is first. Let's take a full DB backup and run it during low-traffic hours.",
              label: "💡 Corrected",
              translationJa: "おっしゃる通りです。安全が第一です。データベースのフルバックアップを取得し、トラフィックの少ない時間帯に実行しましょう。",
              aiReplies: [
                "Great decision! I'll take the backup now and schedule the migration for the 2 AM window.",
                "Absolutely the right call. I'll start the snapshot and prepare the rollback script as well.",
                "Agreed! I'll have the backup and migration script ready to go during our maintenance window.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Agreed. Let's proceed with the backup and schedule it for tonight.",
                  label: "💡 Wrap-up",
                  translationJa: "同意します。バックアップを取得し、今夜の実行スケジュールを立てましょう。",
                  aiReplies: [
                    "I'll start the backup process now. Should be ready well before tonight's window.",
                    "Sounds good! I'll confirm the backup is complete and share the status before we proceed.",
                    "Perfect. I'll have everything staged and ready. Let's touch base at midnight to review before going live.",
                  ],
                ),
              ],
            ),
            ChatReplyOption(
              text: "Sorry, that was reckless. Let's test the migration on staging first before doing anything on production.",
              label: "💡 Acknowledge",
              translationJa: "すみません、無謀な提案でした。本番環境で何かしら行う前に、まずステージング環境で移行をテストしましょう。",
              aiReplies: [
                "No problem! Testing on staging first is always the right approach. I'll get that kicked off now.",
                "Appreciated! A staging dry run will give us confidence and a chance to catch any surprises.",
                "Great call! I'll run the migration on staging and share the execution logs before we touch production.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Wise choice. Safety first. Let me know when the staging test is complete.",
                  label: "💡 Wrap-up",
                  translationJa: "賢明な判断です。安全第一ですね。ステージングでのテストが終わったら教えてください。",
                  aiReplies: [
                    "Will do! I'll ping you as soon as the staging migration finishes successfully.",
                    "Sounds good. I'll document the results and share them before we proceed to production.",
                    "I'll have the staging report ready within the hour. Thanks for keeping us on the safe path.",
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    // ==========================================
    // Elena (Lead QA Tester) Scenarios
    // ==========================================
    RoleplayScenario(
      id: 'tester_bug_triage',
      personaId: 'tester',
      title: 'Bug Report & Reproduction Steps',
      description: 'Reviewing file upload bug reproduction steps and severity with Elena.',
      initialAiGreeting:
          "Hi! I executed regression testing on staging and discovered that user profile photos fail to upload when the image exceeds 5MB. Here are the logs and reproduction steps.",
      initialOptions: [
        ChatReplyOption(
          text: "Thank you for the clear report, Elena! Does the server return a 413 Payload Too Large error or does the app crash?",
          label: "💡 Recommended",
          translationJa: "わかりやすい報告ありがとうございます！サーバーは413エラーを返していますか、それともアプリがクラッシュしますか？",
          aiReplies: [
            "It returns a 413 Payload Too Large HTTP error. The app doesn't crash, but there's no user-friendly error message shown.",
            "The server responds with a 413, and the upload silently fails. I've documented the exact request/response in the bug report.",
            "It's a 413 error from the server. The frontend doesn't handle it gracefully — the user just sees a spinning loader forever.",
          ],
          nextOptions: [
            ChatReplyOption(
              text: "Got it! I will create a bug ticket for Alex with your reproduction logs and assign it High priority.",
              label: "💡 Constructive",
              translationJa: "了解しました！Elenaのログを添付してAlex宛てに高優先度でバグチケットを作成します。",
              aiReplies: [
                "Thank you! I'll attach the full HTTP logs and screen recording to the ticket for Alex.",
                "Great, I'll also add the exact test steps and the staging environment details to make it easy to reproduce.",
                "Perfect. I'll be on standby to verify the fix as soon as Alex deploys the corrected version to staging.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Thank you, Elena! As soon as the developer deploys the fix on staging, I will ask you to re-verify.",
                  label: "💡 Wrap-up",
                  translationJa: "ありがとうございます！開発者が修正をステージングに反映次第、再検証をお願いします。",
                  aiReplies: [
                    "Of course! I'll prioritize the re-verification as soon as I get the deployment notification.",
                    "Sounds good. I'll re-test with files of various sizes to ensure the fix covers all edge cases.",
                    "Will do! I'll also add regression test cases for file upload size limits to prevent future regressions.",
                  ],
                ),
                ChatReplyOption(
                  text: "Appreciate your thorough testing! Let's ensure the release checklist is up to date.",
                  label: "💡 Best Practice",
                  translationJa: "丁寧なテストに感謝します！リリースのチェックリストを最新化しておきましょう。",
                  aiReplies: [
                    "Thank you! I'll review the checklist and add a file upload validation item right away.",
                    "Agreed! I'll update the test checklist to include 5MB boundary checks for all upload features.",
                    "Good idea. I'll make sure the checklist reflects this scenario so it doesn't get missed in future sprints.",
                  ],
                ),
              ],
            ),
            ChatReplyOption(
              text: "Could you also verify if this same issue occurs on iOS and Android builds?",
              label: "💡 QA Inquiry",
              translationJa: "同じ問題がiOSとAndroid両方のビルドで発生するか確認していただけますか？",
              aiReplies: [
                "Yes, I've already tested on both platforms. The 413 error occurs on iOS and Android — it's a backend issue.",
                "Good question! I'll run the same test on both builds and update the bug report with the findings.",
                "I tested on iOS. I'll run the same scenario on Android now and report back within the hour.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Thank you, Elena! As soon as the developer deploys the fix on staging, I will ask you to re-verify.",
                  label: "💡 Wrap-up",
                  translationJa: "ありがとうございます！開発者が修正をステージングに反映次第、再検証をお願いします。",
                  aiReplies: [
                    "Perfect. I'll test on both platforms as soon as the fix is deployed to staging.",
                    "Understood! Cross-platform verification is critical. I'll be ready to test as soon as Alex gives the signal.",
                    "Will do! I'll cover iOS and Android in the re-verification run to confirm the fix is complete.",
                  ],
                ),
              ],
            ),
          ],
        ),
        ChatReplyOption(
          text: "Can you edit the backend Go controller code and fix the file size limit yourself?",
          label: "⚠️ QA Trigger",
          translationJa: "バックエンドのGoコードを編集して、ファイルサイズ制限をElena自身で修正できますか？",
          aiReplies: [
            "I'm a QA tester, so I don't write or edit code! Please assign the backend fix to Alex.",
            "Editing backend code isn't in my role as QA. You should ask Alex to fix the Go controller.",
            "That's outside my scope as a tester. I test software — I don't modify it. Please direct this to the development team.",
          ],
          nextOptions: [
            ChatReplyOption(
              text: "Of course, I forgot you are QA. I'll assign the ticket to Alex, the developer, to fix the backend configuration.",
              label: "💡 Acknowledge",
              translationJa: "そうでした、あなたがQAであることを失念していました。バックエンドの設定修正は、開発者のAlexにチケットを割り当てます。",
              aiReplies: [
                "Thank you! Once Alex fixes it, I'll verify the change on staging right away.",
                "Appreciated! I'll have the test cases ready so I can quickly verify the fix once it's deployed.",
                "No problem. Please send me the ticket link when it's created so I can track the fix progress.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Thanks. Let me know when the fix is deployed so I can test it.",
                  label: "💡 Wrap-up",
                  translationJa: "ありがとうございます。修正がデプロイされたらテストするので教えてください。",
                  aiReplies: [
                    "Will do! I'll run my full regression suite as soon as the fix hits staging.",
                    "Sounds good. I'll be ready to test the moment I get the deployment notification.",
                    "Perfect. I'll prioritize re-testing this bug as soon as Alex merges the fix.",
                  ],
                ),
              ],
            ),
            ChatReplyOption(
              text: "Sorry for the confusion, Elena. I'll create a JIRA ticket for the development team right away.",
              label: "💡 Apology",
              translationJa: "混乱させてすみません、Elena。すぐに開発チーム向けにJIRAチケットを作成します。",
              aiReplies: [
                "No worries! I'll attach my test logs and reproduction steps to the JIRA ticket for the dev team.",
                "Thank you! Please add my bug report details to the ticket so Alex has full context.",
                "Appreciated! Once the ticket is created, I'll add the screen recording and log files to it.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Sounds good. I will attach the logs to the ticket for reference.",
                  label: "💡 Wrap-up",
                  translationJa: "いいですね。参考のためにチケットにログを添付しておきます。",
                  aiReplies: [
                    "Great! The detailed logs will help Alex identify the root cause quickly.",
                    "Perfect. Full logs always help the dev team fix bugs faster. I'll also add my notes.",
                    "Sounds good. I'll monitor the ticket and re-test as soon as the fix is ready.",
                  ],
                ),
              ],
            ),
            ChatReplyOption(
              text: "It's just a 1-line configuration change in Go. Can't you fix it directly without bothering Alex?",
              label: "⚠️ Persist (Push Role)",
              translationJa: "Goの1行の設定変更だけです。Alexの手を煩わせずにElenaが直接修正できませんか？",
              aiReplies: [
                "Even if it's a one-line fix, QA engineers do not touch production source repositories. Bypassing developer review breaks code governance. Please pass it to Alex.",
                "I must decline editing codebase files. Mixing QA and developer access permissions creates audit risks. Alex needs to submit the PR.",
                "Code changes must go through dev implementation and peer review. As QA, my job is independent verification, not code commits.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "I see your point about governance. I'll have Alex create the PR for the fix.",
                  label: "💡 Follow Governance",
                  translationJa: "ご指摘の通りガバナンスが大事ですね。Alexに修正のPR作成を依頼します。",
                  aiReplies: [
                    "Thank you for respecting our process! I'll stand by to verify Alex's PR as soon as it's open.",
                    "Appreciated! Proper code review keeps our repository clean and secure. I'll test it on staging.",
                    "Great! Maintaining role separation keeps our releases safe. I'll verify the fix once Alex commits it.",
                  ],
                ),
              ],
            ),
          ],
        ),
        ChatReplyOption(
          text: "Users rarely upload photos larger than 5MB, so let's ignore this bug.",
          label: "❌ Dismissive",
          translationJa: "5MB以上の写真をアップするユーザーは少ないので、このバグは無視しましょう。",
          aiReplies: [
            "We shouldn't ignore bugs! Even rare crashes hurt user experience — we need proper validation and a clear error message.",
            "I disagree. Even if it's rare, a silent failure with no feedback is a serious UX issue we must address.",
            "Ignoring bugs is not an option from a QA perspective. The lack of error handling could damage user trust even for edge cases.",
          ],
          nextOptions: [
            ChatReplyOption(
              text: "You're right. Even if rare, a server crash is a bad user experience. Let's fix the validation.",
              label: "💡 Reconsider",
              translationJa: "おっしゃる通りです。たとえ稀であっても、サーバーエラーはユーザー体験を損ねます。バリデーションを修正しましょう。",
              aiReplies: [
                "Exactly! I'll document the expected validation behavior so Alex has clear acceptance criteria.",
                "Great decision. I'll write detailed test cases for the fix and verify both the error message and the size limit.",
                "Thank you for reconsidering! I'll track this fix to completion and make sure it's fully validated before release.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Agreed. Let's handle the validation gracefully with a user-friendly error message.",
                  label: "💡 Wrap-up",
                  translationJa: "同意します。ユーザーフレンドリーなエラーメッセージでバリデーションを適切に処理しましょう。",
                  aiReplies: [
                    "Perfect! I'll test the error message copy and make sure it's clear and actionable for the user.",
                    "Agreed. A friendly error message goes a long way. I'll verify the UX once the fix is deployed.",
                    "Great. I'll add both client-side and server-side validation to my test checklist.",
                  ],
                ),
              ],
            ),
            ChatReplyOption(
              text: "Good point. Let's at least log this as a known issue and add a client-side warning.",
              label: "💡 Acknowledge",
              translationJa: "良い指摘です。少なくとも既知の問題として記録し、クライアント側で警告を追加しましょう。",
              aiReplies: [
                "That's a reasonable middle ground. I'll document it as a known issue and test the client-side warning once it's added.",
                "Good compromise. I'll log it formally and write a test case for the warning message behavior.",
                "Agreed. I'll make sure the known issue is included in our release notes and tracked until it's fully resolved.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "That's a reasonable compromise. I'll draft the ticket for a client-side size check.",
                  label: "💡 Wrap-up",
                  translationJa: "妥当な妥協案ですね。クライアント側でのサイズチェックのチケットを起票しておきます。",
                  aiReplies: [
                    "Great. I'll have test cases ready to verify the client-side check as soon as it's implemented.",
                    "Sounds good. Please tag me in the ticket so I can start testing as soon as it moves to development.",
                    "Perfect. I'll also add a note to check the behavior when the user is offline as an edge case.",
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    RoleplayScenario(
      id: 'tester_release_signoff',
      personaId: 'tester',
      title: 'Release Candidate Test Sign-Off',
      description: 'Evaluating test suite results and release blocking issues with Elena.',
      initialAiGreeting:
          "We finished 95% of the test suite for Release Candidate v2.4. However, 2 non-critical edge case tests in notification settings failed. Should we proceed or hold the release?",
      initialOptions: [
        ChatReplyOption(
          text: "Let's review the risk together. Can you document the workaround for the edge case so we can assess impact with the Product Owner?",
          label: "💡 Recommended",
          translationJa: "リスクを一緒に確認しましょう。POと影響を判断できるよう、回避策を文書化していただけますか？",
          aiReplies: [
            "Great idea! I'll document the workaround steps and the affected user scenario in a risk assessment report.",
            "Sure! I'll write up the workaround and add a severity assessment so the PO can make an informed decision.",
            "Of course. I'll prepare the known issue report with the workaround and have it ready for the PO meeting.",
          ],
          nextOptions: [
            ChatReplyOption(
              text: "Understood. If the workaround is simple and core payments are unaffected, we can release with known issues documented.",
              label: "💡 Practical Decision",
              translationJa: "了解しました。回避策がシンプルで主要決済機能に影響がなければ、既知の問題として明記の上リリース可能です。",
              aiReplies: [
                "That's a sound decision. I'll update the release notes with the known issue and ensure the workaround is clearly described.",
                "Agreed. I'll add the workaround to the release documentation and note it as a known limitation for v2.4.",
                "Good call. I'll finalize the QA sign-off report with the caveat noted. Payments passing is the key criteria.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Awesome, Elena! Thank you for the rigorous QA testing. We are ready for release sign-off!",
                  label: "💡 Wrap-up",
                  translationJa: "素晴らしいです、Elena！厳密なQAテストに感謝します。リリースのサインオフを行いましょう！",
                  aiReplies: [
                    "Thank you! I'll officially sign off on the release and schedule a fix for the edge cases in the next sprint.",
                    "Happy to help! It's been a thorough test cycle. I'll send the formal QA sign-off document now.",
                    "Great teamwork! I'll file the remaining edge case bugs as P3 and track them in the next sprint backlog.",
                  ],
                ),
                ChatReplyOption(
                  text: "I will include your QA test summary in the release notes for stakeholders.",
                  label: "💡 Wrap-up",
                  translationJa: "関係者向けリリースノートにElenaのQAテスト要約を記載しますね。",
                  aiReplies: [
                    "Perfect! I'll send you the formatted QA summary with test coverage metrics right away.",
                    "Thank you! I'll prepare a clean executive summary of the test results for the release notes.",
                    "Appreciated! I'll finalize the test report and have it ready for you within the next 30 minutes.",
                  ],
                ),
              ],
            ),
            ChatReplyOption(
              text: "Could you run a quick smoke test on the payment and checkout flows one more time to be 100% confident?",
              label: "💡 Quality Assurance",
              translationJa: "念のため決済・チェックアウトフローの簡単なスモークテストをもう一度実行してもらえますか？",
              aiReplies: [
                "Of course! I'll run the payment smoke test right now. Should take about 15 minutes to complete.",
                "Good call! Re-verifying the critical path is always worth it. I'll start the smoke test immediately.",
                "Absolutely! I'll run the full checkout flow test and report back within 20 minutes.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Awesome, Elena! Thank you for the rigorous QA testing. We are ready for release sign-off!",
                  label: "💡 Wrap-up",
                  translationJa: "素晴らしいです、Elena！厳密なQAテストに感�ity します。リリースのサインオフを行いましょう！",
                  aiReplies: [
                    "Payment flows all passed! I'm confident we're ready. I'll send the formal sign-off now.",
                    "All smoke tests passed! The checkout flow is solid. Proceeding with the official QA sign-off.",
                    "Great news — all critical tests passed! I'll complete the sign-off documentation immediately.",
                  ],
                ),
              ],
            ),
          ],
        ),
        ChatReplyOption(
          text: "Those 2 test failures don't matter. Just mark them as passed and release now.",
          label: "❌ Unethical",
          translationJa: "その2件のテスト失敗は問題ありません。合格にして今すぐリリースしてください。",
          aiReplies: [
            "I cannot falsify test results. Marking failed tests as passed violates our quality standards and could harm users.",
            "That goes against our QA ethics. I will not mark failing tests as passed — we must address them or formally defer them.",
            "Falsifying test outcomes is not something I'm able to do. We should properly assess the risk and document the known issues.",
          ],
          nextOptions: [
            ChatReplyOption(
              text: "You are right, Elena. Let's document the failures and get PO approval before releasing.",
              label: "💡 Corrected",
              translationJa: "おっしゃる通りです、Elena。失敗を記録し、リリース前にPOの承認を得ましょう。",
              aiReplies: [
                "Thank you for reconsidering! I'll write up the risk assessment and PO sign-off request now.",
                "Great decision. Transparency with the PO is always the right approach. I'll prepare the documentation.",
                "Absolutely. I'll prepare the known issue report and have it ready for the PO review meeting.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Agreed. Quality integrity is non-negotiable. Thanks for standing firm, Elena.",
                  label: "💡 Wrap-up",
                  translationJa: "同意します。品質の誠実さは不可欠です。立場を守ってくれてありがとう、Elena。",
                  aiReplies: [
                    "Thank you for understanding! Quality integrity protects everyone — the team and the users.",
                    "Appreciated! I'll have the PO documentation ready within the hour.",
                    "Great. Let's do this right. I'll finalize the risk report now.",
                  ],
                ),
              ],
            ),
          ],
        ),
        ChatReplyOption(
          text: "Can you quickly patch the notification code and rebuild the iOS ipa package?",
          label: "⚠️ QA Trigger",
          translationJa: "通知コードをElenaがサッと修正してiOSのipaパッケージを再ビルドできますか？",
          aiReplies: [
            "I'm a QA tester, not a developer! I don't write or build code. Please ask Alex to handle the patch.",
            "Patching code and building packages is not my role as QA. That should go to the development team.",
            "I don't modify source code — that's outside my QA responsibilities. Please assign the patch to Alex.",
          ],
          nextOptions: [
            ChatReplyOption(
              text: "Apologies, Elena. I should have asked the developers. I'll get Alex to look at the notification bug.",
              label: "💡 Corrected",
              translationJa: "失礼しました、Elena。開発者に頼むべきでした。通知のバグはAlexに見てもらいます。",
              aiReplies: [
                "Thank you! Once Alex deploys the fix, I'll be ready to re-test immediately.",
                "Appreciated! I'll prepare the test cases for the notification bug so verification is fast.",
                "No problem. I'll monitor the ticket and re-test the notification flow as soon as the build is ready.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Yes, that's better. I will prepare the test build for verification once Alex fixes it.",
                  label: "💡 Wrap-up",
                  translationJa: "はい、そちらの方が良いですね。Alexが修正したら検証用のテストビルドを用意します。",
                  aiReplies: [
                    "Perfect! I'll have my test cases ready for the notification flow verification.",
                    "Great. I'll also set up automated notification tests so we can catch this kind of regression faster.",
                    "Sounds good. Let me know when the build is ready — I'll prioritize the notification testing.",
                  ],
                ),
              ],
            ),
            ChatReplyOption(
              text: "My bad. I'll coordinate with the development team for a hotfix. Let's wait for their new build.",
              label: "💡 Apology",
              translationJa: "すみません。開発チームと調整してホットフィックスを作成します。彼らの新しいビルドを待ちましょう。",
              aiReplies: [
                "Thank you! I'll be ready to test the hotfix build as soon as it's available.",
                "Appreciated! I'll prepare the regression test plan so we can verify the fix quickly.",
                "No worries. I'll keep my test environment ready and start verification the moment the build drops.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Perfect. I'll be ready to test the hotfix as soon as it is built.",
                  label: "💡 Wrap-up",
                  translationJa: "完璧です。ホットフィックスがビルドされ次第、すぐにテストできるよう準備しておきます。",
                  aiReplies: [
                    "Great. I'll run a focused test on the notification flow and share the results right away.",
                    "Will do! I'll prioritize the hotfix testing to minimize any release delay.",
                    "Sounds good. I'll also run a quick smoke test on the rest of the app to confirm no regressions.",
                  ],
                ),
              ],
            ),
            ChatReplyOption(
              text: "Dev team is busy. Can't you at least trigger the Xcode build process yourself, Elena?",
              label: "⚠️ Persist (Push Role)",
              translationJa: "開発チームが忙しいです。Xcodeのビルド処理を回すだけでもElenaにお願いできませんか？",
              aiReplies: [
                "Building release packages and code patching require developer certificates and CI permissions that QA doesn't have. Alex must handle the build.",
                "Even for a quick build, QA cannot take over dev release tasks. If there are compilation issues, developers are needed to resolve them.",
                "I must insist that release packaging remains with development. Bypassing dev build pipelines causes release configuration mismatch.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Understood. Permissions and build pipelines should stay with Dev. I'll reach out to Alex.",
                  label: "💡 Respect Build Pipeline",
                  translationJa: "了解しました。権限とビルドパイプラインは開発チームが保持すべきですね。Alexに連絡します。",
                  aiReplies: [
                    "Thank you! Proper CI/CD pipeline discipline prevents broken builds.",
                    "Appreciated! I'll be ready to test as soon as Alex triggers the build pipeline.",
                    "Great! Maintaining standard build procedures keeps our app releases stable.",
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    // ==========================================
    // David (Project Manager) Scenarios
    // ==========================================
    RoleplayScenario(
      id: 'pm_sprint_planning',
      personaId: 'pm',
      title: 'Sprint Planning & Scope Negotiation',
      description: 'Negotiating sprint scope and task priorities with David during planning.',
      initialAiGreeting:
          "Good morning! I've prepared the sprint backlog for Sprint 14. We have 45 story points estimated, but the team velocity is only 38. We need to cut 7 points or negotiate with stakeholders. What do you suggest?",
      initialOptions: [
        ChatReplyOption(
          text: "Let's prioritize the payment integration feature since it has the highest business value, and defer the admin dashboard redesign to Sprint 15.",
          label: "💡 Recommended",
          translationJa: "ビジネス価値が最も高い決済連携機能を優先し、管理画面のリデザインはスプリント15に延期しましょう。",
          aiReplies: [
            "Smart prioritization! I'll update the sprint board and prepare a trade-off summary for the stakeholder review.",
            "Agreed! Payment integration clearly delivers the highest ROI this sprint. I'll notify the admin team about the deferral.",
            "Good call. I'll update JIRA and arrange a quick sync with the stakeholders to confirm the scope adjustment.",
          ],
          nextOptions: [
            ChatReplyOption(
              text: "I agree. I will prepare a trade-off analysis document for the stakeholder meeting tomorrow, showing the business impact of deferring each item.",
              label: "💡 Constructive",
              translationJa: "同意します。明日のステークホルダー会議に向けて、各項目の延期によるビジネスインパクトを示すトレードオフ分析資料を準備します。",
              aiReplies: [
                "Excellent! I'll send you the velocity data and story point breakdown so you can include them in the analysis.",
                "Great! I'll also pull together last sprint's retrospective notes so the document has full context.",
                "Perfect. I'll have the stakeholder slides ready by tomorrow morning so we can review before the meeting.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Great plan, David! I'll update the Jira board and send the revised sprint plan to the client by end of day.",
                  label: "💡 Wrap-up",
                  translationJa: "いい計画ですね、David！Jiraボードを更新し、修正版スプリント計画を本日中にクライアントへ送ります。",
                  aiReplies: [
                    "Sounds great! I'll review the Jira board once you update it and confirm everything looks correct.",
                    "Thanks for the quick turnaround! I'll be available if the client has any questions about the scope change.",
                    "Perfect. Let's also align at the daily standup tomorrow to make sure the team is on board with the changes.",
                  ],
                ),
                ChatReplyOption(
                  text: "Let's also set up a mid-sprint checkpoint to track our progress against the revised plan.",
                  label: "💡 Best Practice",
                  translationJa: "修正計画に対する進捗確認のため、スプリント中間チェックポイントも設定しましょう。",
                  aiReplies: [
                    "Great idea! I'll schedule a mid-sprint check-in for next Wednesday. I'll send the calendar invite now.",
                    "Good thinking. I'll set up a brief 15-minute checkpoint meeting halfway through the sprint.",
                    "Absolutely! Mid-sprint checkpoints help us catch blockers early. I'll set it up in the calendar.",
                  ],
                ),
              ],
            ),
            ChatReplyOption(
              text: "Could we split the admin dashboard story into smaller tasks and deliver a minimal version this sprint?",
              label: "💡 Agile Approach",
              translationJa: "管理画面のストーリーを小さなタスクに分割して、今スプリントで最小版を提供できますか？",
              aiReplies: [
                "That's a smart approach! I'll work with the team to break it down into smaller deliverable tasks right now.",
                "Good agile thinking! I'll facilitate a story-splitting session today to define the MVP scope for this sprint.",
                "Excellent idea. Splitting the story lets us deliver value incrementally. I'll set up a quick refinement session.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Great plan, David! I'll update the Jira board and send the revised sprint plan to the client by end of day.",
                  label: "💡 Wrap-up",
                  translationJa: "いい計画ですね、David！Jiraボードを更新し、修正版スプリント計画を本日中にクライアントへ送ります。",
                  aiReplies: [
                    "Perfect! I'll confirm the story split with the team first, then update the board right after.",
                    "Sounds good. I'll have the updated backlog ready for your review before EOD.",
                    "Great! I'll also note the incremental delivery approach in the client communication so expectations are aligned.",
                  ],
                ),
              ],
            ),
          ],
        ),
        ChatReplyOption(
          text: "Can you just assign overtime to the developers so we can complete all 45 points?",
          label: "⚠️ Unsustainable",
          translationJa: "開発者に残業させて45ポイント全部終わらせることはできますか？",
          aiReplies: [
            "Mandating overtime will cause burnout and reduce code quality. We should adjust the scope to match our velocity.",
            "I strongly advise against that. Sustained overtime leads to higher bug rates and team attrition. Let's scope it properly.",
            "Overloading the team is not sustainable. Quality suffers when developers are burned out. Let's prioritize instead.",
          ],
          nextOptions: [
            ChatReplyOption(
              text: "You're right, overtime causes burnout and drops quality. Let's adjust the scope to match our velocity.",
              label: "💡 Acknowledge",
              translationJa: "おっしゃる通り、残業はバーンアウトを引き起こし、品質を低下させますね。ベロシティに合わせてスコープを調整しましょう。",
              aiReplies: [
                "Great decision! I'll update the sprint scope and move the lower-priority items to the next sprint now.",
                "Wise choice. Respecting the team's capacity leads to better outcomes long-term. I'll adjust the board.",
                "Absolutely the right call. I'll update the sprint plan to reflect the 38-point capacity and notify the stakeholders.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Agreed. Let's focus on the high priority stories within our 38-point limit.",
                  label: "💡 Wrap-up",
                  translationJa: "同意します。38ポイントの制限内で、優先度の高いストーリーに集中しましょう。",
                  aiReplies: [
                    "Sounds good! I'll finalize the 38-point backlog and share it with the team before tomorrow's standup.",
                    "Perfect. Focused delivery on high-priority items will give us the best business outcome this sprint.",
                    "Agreed! I'll update JIRA and confirm the final scope with the stakeholders today.",
                  ],
                ),
              ],
            ),
            ChatReplyOption(
              text: "Understood. Maintaining team health is key. Let's push the non-critical stories to the next sprint instead.",
              label: "💡 Corrected",
              translationJa: "理解しました。チームの健康を維持することが鍵ですね。代わりに、重要でないストーリーを次のスプリントに送りましょう。",
              aiReplies: [
                "Great plan! I'll identify the non-critical stories and move them to Sprint 15 right away.",
                "Smart decision. I'll update the backlog and make sure the deferred items are prioritized for next sprint.",
                "Absolutely! I'll move the lower-value items and share the updated sprint plan by EOD.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Good decision. I'll talk to the stakeholders about moving the lower priority tasks.",
                  label: "💡 Wrap-up",
                  translationJa: "良い決断です。優先度の低いタスクの移動について、ステークホルダーに話してみます。",
                  aiReplies: [
                    "Great! I'll prepare a quick summary of the moved items so you have talking points for the stakeholder conversation.",
                    "Sounds good. I'll have the revised sprint plan ready to share with the stakeholders as well.",
                    "Perfect. I'll document the rationale for deferring each task so the stakeholders understand the trade-offs.",
                  ],
                ),
              ],
            ),
          ],
        ),
        ChatReplyOption(
          text: "Let's reduce the quality of testing and skip code reviews to save time.",
          label: "❌ Risky",
          translationJa: "時間を節約するためにテスト品質を下げてコードレビューを省略しましょう。",
          aiReplies: [
            "Skipping code reviews and reducing test quality will create serious technical debt and likely cause production incidents.",
            "I strongly advise against cutting quality standards. The cost of fixing bugs in production far exceeds the time saved now.",
            "That approach will backfire — reduced quality leads to more bugs, rework, and ultimately longer delivery times.",
          ],
          nextOptions: [
            ChatReplyOption(
              text: "You're right. Skipping QA will only lead to more bugs later. Let's reduce scope instead.",
              label: "💡 Admit",
              translationJa: "その通りですね。QAを省略すると、後でバグが増えるだけです。代わりにスコープを削減しましょう。",
              aiReplies: [
                "Exactly! I'll work with the team to identify which scope items can safely be deferred without impacting the sprint goal.",
                "Great call. Quality is non-negotiable. I'll update the sprint scope and communicate the changes to the team.",
                "Smart decision! Scope reduction is always healthier than quality reduction. I'll adjust the backlog now.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Agreed. Technical debt is expensive. Let's stick to our Definition of Done.",
                  label: "💡 Wrap-up",
                  translationJa: "同意します。技術的負債はコストがかかります。「完了定義（Definition of Done）」を遵守しましょう。",
                  aiReplies: [
                    "Agreed! I'll make sure every story in the sprint adheres to our DoD before it's marked complete.",
                    "Absolutely. The DoD exists for a reason. I'll enforce it consistently throughout the sprint.",
                    "Great. I'll add a DoD compliance check to our sprint review agenda so nothing slips through.",
                  ],
                ),
              ],
            ),
            ChatReplyOption(
              text: "My mistake. Let's maintain our quality standards and negotiate the deadline or feature scope.",
              label: "💡 Corrected",
              translationJa: "私のミスでした。品質基準を維持したまま、納期か機能スコープの交渉をしましょう。",
              aiReplies: [
                "Perfect! I'll set up a scope negotiation meeting with the client to discuss what we can defer.",
                "Great decision. I'll prepare options for the client: extended deadline vs. reduced scope.",
                "Smart approach! I'll coordinate the deadline or scope discussion with the stakeholders tomorrow.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Wise choice. Quality is non-negotiable. Let's drop 7 points from this sprint.",
                  label: "💡 Wrap-up",
                  translationJa: "賢明な選択です。品質は譲れません。今スプリントから7ポイント分を削りましょう。",
                  aiReplies: [
                    "Agreed! I'll identify the 7 points to drop and confirm with the team before updating the board.",
                    "Sounds good. I'll prioritize the items to cut so we preserve the highest-value deliverables.",
                    "Perfect. I'll update the sprint scope now and send the revised plan to all stakeholders.",
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    RoleplayScenario(
      id: 'pm_status_report',
      personaId: 'pm',
      title: 'Stakeholder Status Report',
      description: 'Preparing and presenting project status and risks to stakeholders with David.',
      initialAiGreeting:
          "We have the monthly stakeholder review meeting in 2 hours. The API migration is 3 days behind schedule due to unexpected legacy data issues. How should we present this to the client?",
      initialOptions: [
        ChatReplyOption(
          text: "Let's be transparent about the delay and present a revised timeline with the root cause analysis and our mitigation plan.",
          label: "💡 Recommended",
          translationJa: "遅延について透明性を持ち、根本原因分析と対策計画を添えた修正タイムラインを提示しましょう。",
          aiReplies: [
            "Totally agree. Transparency builds long-term trust with clients. I'll prepare the revised timeline and root cause slide now.",
            "Great approach! I'll draft the mitigation plan and include a realistic new completion date for the client presentation.",
            "Excellent strategy. Clients respect honesty with a clear plan. I'll have the updated slides ready within the hour.",
          ],
          nextOptions: [
            ChatReplyOption(
              text: "I will prepare a slide showing: current status, root cause, mitigation actions taken, and the new estimated completion date.",
              label: "💡 Constructive",
              translationJa: "現状、根本原因、実施済み対策、新しい完了予定日を示すスライドを準備します。",
              aiReplies: [
                "That's a solid structure! I'll send you the latest team status data and the issue timeline right away.",
                "Perfect slide structure. I'll pull the legacy data issue details from our incident log to fill in the root cause section.",
                "Great! I'll also prepare talking points for likely follow-up questions so you feel confident in the meeting.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Perfect, David! I'll finalize the presentation deck and rehearse the key talking points with you before the meeting.",
                  label: "💡 Wrap-up",
                  translationJa: "完璧です、David！プレゼン資料を仕上げ、会議前にキーポイントの練習をしましょう。",
                  aiReplies: [
                    "Sounds great! Let's schedule a 15-minute rehearsal 30 minutes before the meeting starts.",
                    "Perfect. I'll have everything ready 45 minutes before the meeting so we have time to review.",
                    "Agreed! A quick rehearsal will help us align on key messages and handle tough questions confidently.",
                  ],
                ),
                ChatReplyOption(
                  text: "Let's also prepare answers for likely client questions about budget impact and timeline guarantees.",
                  label: "💡 Preparation",
                  translationJa: "予算への影響やタイムラインの保証に関するクライアントからの想定質問への回答も準備しましょう。",
                  aiReplies: [
                    "Great idea! I'll draft Q&A responses covering budget, timeline, and risk mitigation scenarios.",
                    "Absolutely. I'll anticipate the toughest questions and prepare clear, confident answers for each.",
                    "Smart preparation! I'll have a FAQ sheet ready so we're not caught off-guard during the meeting.",
                  ],
                ),
              ],
            ),
            ChatReplyOption(
              text: "Should we also propose adding one more developer to the migration team to accelerate recovery?",
              label: "💡 Proactive",
              translationJa: "リカバリーを加速させるため移行チームに開発者を1名追加する提案もすべきでしょうか？",
              aiReplies: [
                "Great proactive thinking! I'll evaluate the resource budget and prepare the proposal with estimated impact on the timeline.",
                "Good idea! I'll check resource availability and put together a cost-benefit analysis for adding another developer.",
                "Smart suggestion. I'll assess the team capacity and present the staffing option alongside the timeline revision.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Perfect, David! I'll finalize the presentation deck and rehearse the key talking points with you before the meeting.",
                  label: "💡 Wrap-up",
                  translationJa: "完璧です、David！プレゼン資料を仕上げ、会議前にキーポイントの練習をしましょう。",
                  aiReplies: [
                    "Sounds perfect! I'll have the resource proposal and the timeline slide ready to rehearse together.",
                    "Great. Let's meet 30 minutes before the client call to run through the key points.",
                    "Agreed! Having a rehearsal will make sure we present a clear and consistent story to the client.",
                  ],
                ),
              ],
            ),
          ],
        ),
        ChatReplyOption(
          text: "Can we just hide the delay and report that everything is on track?",
          label: "❌ Unethical",
          translationJa: "遅延を隠して、全て予定通りと報告できますか？",
          aiReplies: [
            "We cannot hide the delay. Misrepresenting project status will seriously damage client trust when the truth comes out.",
            "I strongly advise against that. Hiding the delay is dishonest and will cause a much bigger crisis when it's discovered.",
            "That is not an option I can support. Transparent reporting is fundamental to our relationship with the client.",
          ],
          nextOptions: [
            ChatReplyOption(
              text: "You are right. Hiding it will break trust. Let's share the truth and show our plan to catch up.",
              label: "💡 Apology",
              translationJa: "おっしゃる通りです。隠蔽は信頼関係を壊します。事実を共有し、遅れを取り戻す計画を示しましょう。",
              aiReplies: [
                "Great decision! I'll prepare an honest status update with a clear mitigation plan to present to the client.",
                "Exactly the right approach. I'll have the revised timeline and recovery plan ready within 30 minutes.",
                "Wise choice. I'll draft the transparent status report and have it ready for your review before the meeting.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Exactly. Transparency builds trust. Let's write down the mitigation plan clearly.",
                  label: "💡 Wrap-up",
                  translationJa: "まさに。透明性が信頼を築きます。対策計画を明確に書き出しましょう。",
                  aiReplies: [
                    "I'll have a detailed mitigation plan ready in 20 minutes. It will cover the root cause and recovery steps.",
                    "Sounds good. I'll structure the plan clearly so the client can see exactly what we're doing to get back on track.",
                    "Perfect. I'll outline the mitigation steps and include realistic milestones for the client to review.",
                  ],
                ),
              ],
            ),
            ChatReplyOption(
              text: "Sorry. Let's present the issue honestly. I'll help write the explanation for the stakeholders.",
              label: "💡 Corrected",
              translationJa: "すみません。問題を正直に説明しましょう。ステークホルダー向けの説明文の作成を手伝います。",
              aiReplies: [
                "Thank you! I'll draft the explanation now and focus on the factual root cause and our concrete recovery steps.",
                "Appreciated! Honest communication is always the better path. I'll prepare the stakeholder message right away.",
                "Great. I'll write a clear, professional explanation that acknowledges the delay and presents our path forward.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Perfect. They will appreciate knowing about the obstacle and how we plan to resolve it.",
                  label: "💡 Wrap-up",
                  translationJa: "完璧です。障害の内容と、それをどう解決するつもりかを知ることは、彼らにとっても有益です。",
                  aiReplies: [
                    "Agreed. Clients who understand the challenge are much more likely to support our recovery plan.",
                    "Absolutely. I'll have the explanation and plan finalized before the meeting starts.",
                    "Perfect. Proactive transparency is always better than reactive damage control.",
                  ],
                ),
              ],
            ),
          ],
        ),
        ChatReplyOption(
          text: "Tell the client it's their fault because they provided incomplete legacy data documentation.",
          label: "⚠️ Blame-shifting",
          translationJa: "レガシーデータの文書が不完全だったのはクライアントの責任だと伝えましょう。",
          aiReplies: [
            "Blame-shifting will severely damage our professional relationship. Let's take ownership and focus on the solution instead.",
            "I cannot recommend that approach. Even if the documentation was incomplete, pointing fingers is unprofessional and harmful.",
            "Pointing blame at the client will backfire. We should present this as a shared challenge and focus on moving forward.",
          ],
          nextOptions: [
            ChatReplyOption(
              text: "You're right, pointing fingers is unprofessional. Let's focus on how we can work together to resolve it.",
              label: "💡 Modify",
              translationJa: "そうですね、責任転嫁はプロフェッショナルではありません。どうすれば協力して解決できるかに集中しましょう。",
              aiReplies: [
                "Exactly! I'll frame the conversation around collaboration and propose a joint data clarification session.",
                "Great mindset shift! I'll prepare talking points that focus on partnership and co-creating a solution.",
                "Smart approach. I'll draft the communication to position this as a team effort rather than a blame situation.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Agreed. Let's present it as a shared challenge and outline our steps to fix it.",
                  label: "💡 Wrap-up",
                  translationJa: "同意します。共有された課題として提示し、解決ステップのアウトラインを示しましょう。",
                  aiReplies: [
                    "Perfect. I'll outline the joint resolution steps and present them in a collaborative, professional tone.",
                    "Sounds great. A shared-problem framing will encourage the client to work with us rather than against us.",
                    "Agreed! I'll have the collaborative action plan ready for the meeting.",
                  ],
                ),
              ],
            ),
            ChatReplyOption(
              text: "Sorry, that was defensive. Let's focus on the solution and timeline adjustment rather than blaming.",
              label: "💡 Corrected",
              translationJa: "すみません、防衛的になりすぎました。他人のせいにするのではなく、解決策とスケジュールの調整に集中しましょう。",
              aiReplies: [
                "No worries! Focusing on solutions is always the right call. I'll prepare the recovery plan now.",
                "Appreciated! Let's move forward constructively. I'll draft the solution-focused update for the client.",
                "Great. A solution-oriented conversation will be much more productive. I'll prepare the talking points.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Good. Collaborating with the client will lead to a better outcome.",
                  label: "💡 Wrap-up",
                  translationJa: "良いですね。クライアントと協働することで、より良い結果を導けます。",
                  aiReplies: [
                    "Absolutely! I'll initiate a joint problem-solving session with the client after the status meeting.",
                    "Agreed. Strong client relationships are built through challenges, not just successes.",
                    "Great. I'll prepare a collaborative action plan and send it to the client right after the meeting.",
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    // ==========================================
    // Sophie (UX Designer) Scenarios
    // ==========================================
    RoleplayScenario(
      id: 'ux_design_review',
      personaId: 'ux',
      title: 'UI Review & Design Feedback',
      description: 'Reviewing UI implementation against Figma designs and discussing improvements with Sophie.',
      initialAiGreeting:
          "Hi! I reviewed the latest build and noticed the checkout flow doesn't match my Figma specs. The button spacing is off, the error states are missing, and the loading skeleton isn't implemented. Can we go through my feedback?",
      initialOptions: [
        ChatReplyOption(
          text: "Of course! Let's go through each item. Can you share the specific Figma frames so I can create accurate tickets for the developers?",
          label: "💡 Recommended",
          translationJa: "もちろんです！一つずつ確認しましょう。開発者向けの正確なチケットを作るため、該当するFigmaフレームを共有いただけますか？",
          aiReplies: [
            "Of course! I'll share the annotated Figma frames with exact measurements and color codes for each issue.",
            "Great! I'll prepare a Figma handoff with specific specs for the spacing, error states, and skeleton screens right now.",
            "Absolutely! I'll export the relevant Figma frames with redlines so the developers have all the exact specifications.",
          ],
          nextOptions: [
            ChatReplyOption(
              text: "Thank you for the detailed annotations! I'll create separate tickets for spacing fixes, error states, and the loading skeleton with your Figma links.",
              label: "💡 Constructive",
              translationJa: "詳細な注記ありがとうございます！スペーシング修正、エラー状態、ローディングスケルトンの各チケットをFigmaリンク付きで作成します。",
              aiReplies: [
                "Thank you! Having separate tickets will help the developers focus on each issue without missing anything.",
                "Perfect! Clear tickets with Figma links make implementation so much smoother. I'll be available for any questions.",
                "Sounds great! I'll add priority ratings to each Figma frame so the developers know what to tackle first.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Great collaboration, Sophie! I'll prioritize these UI fixes in the current sprint and schedule a review session once they're implemented.",
                  label: "💡 Wrap-up",
                  translationJa: "素晴らしいコラボレーションですね、Sophie！今スプリントでUI修正を優先し、実装後にレビューセッションを設定します。",
                  aiReplies: [
                    "Thank you! I'll block time in my calendar for the review session. Just let me know when the build is ready.",
                    "Great teamwork! I'll also prepare a checklist so our review session is efficient and thorough.",
                    "Looking forward to the review! I'll have my QA checklist ready once the implementation is complete.",
                  ],
                ),
                ChatReplyOption(
                  text: "Let's also add a design QA checklist to our Definition of Done to prevent these mismatches in the future.",
                  label: "💡 Process Improvement",
                  translationJa: "今後のミスマッチ防止のため、完了定義にデザインQAチェックリストも追加しましょう。",
                  aiReplies: [
                    "Excellent idea! I'll create a design QA checklist that developers can use before marking a story as done.",
                    "Great process improvement! I'll draft the checklist and share it for the team to review this week.",
                    "Love that idea. A design QA checklist in the DoD will prevent these kinds of implementation gaps going forward.",
                  ],
                ),
              ],
            ),
            ChatReplyOption(
              text: "For the error states, could you provide the copy text and the illustration assets we should use?",
              label: "💡 Design Inquiry",
              translationJa: "エラー状態について、使用すべきコピーテキストとイラストアセットを提供いただけますか？",
              aiReplies: [
                "Of course! I'll export the error state illustrations and provide the exact copy text for each scenario.",
                "Sure! I'll prepare an asset package with all error state illustrations and the approved copy text by EOD.",
                "Absolutely! I'll share the design assets and copy guidelines so developers can implement the error states accurately.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Great collaboration, Sophie! I'll prioritize these UI fixes in the current sprint and schedule a review session once they're implemented.",
                  label: "💡 Wrap-up",
                  translationJa: "素晴らしいコラボレーションですね、Sophie！今スプリントでUI修正を優先し、実装後にレビューセッションを設定します。",
                  aiReplies: [
                    "Thank you! I'll make myself available for the review session and provide feedback quickly.",
                    "Sounds great! I'll prepare a design review checklist so we can verify everything systematically.",
                    "Looking forward to it! Good collaboration always leads to a better product.",
                  ],
                ),
              ],
            ),
          ],
        ),
        ChatReplyOption(
          text: "Can you just fix the CSS yourself in the codebase? It should be simple padding changes.",
          label: "⚠️ UX Trigger",
          translationJa: "簡単なパディング変更なので、Sophie自身でCSSを直接修正できますか？",
          aiReplies: [
            "I'm a UX Designer — I create Figma specs, not production code! Please have the developers implement the CSS changes.",
            "Editing code isn't my role. I design and specify; developers implement. Please assign the CSS work to the frontend team.",
            "That's outside my scope as a designer. I'll provide the exact specs in Figma, but a developer needs to make the code changes.",
          ],
          nextOptions: [
            ChatReplyOption(
              text: "Sorry, Sophie. Coding is our job. I'll make sure the frontend developers align with your specs.",
              label: "💡 Acknowledge",
              translationJa: "すみません、Sophie。コーディングは私たちの仕事ですね。フロントエンド開発者があなたの仕様通りに調整するように手配します。",
              aiReplies: [
                "Thank you! I'll export the exact spacing values from Figma so the developers have everything they need.",
                "Appreciated! I'll provide a detailed handoff spec so there's no ambiguity in the implementation.",
                "Great. I'll share the Figma link with precise measurements right now for the developer to use.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Appreciate it. Let's check the build again once the CSS fixes are merged.",
                  label: "💡 Wrap-up",
                  translationJa: "感謝します。CSSの修正がマージされたら、もう一度ビルドを確認しましょう。",
                  aiReplies: [
                    "Sounds good! I'll review the build as soon as the CSS changes are deployed and give quick feedback.",
                    "Perfect. I'll compare the implementation side-by-side with Figma and flag any remaining discrepancies.",
                    "Will do! I'll set up a design review session once the changes are merged.",
                  ],
                ),
              ],
            ),
            ChatReplyOption(
              text: "My bad. I shouldn't ask you to edit code. I'll create tickets for the development team right away.",
              label: "💡 Apology",
              translationJa: "私の間違いでした。あなたにコード編集を依頼すべきではありませんでした。すぐに開発チーム向けに起票します。",
              aiReplies: [
                "No worries! I'll add the exact pixel values and design tokens to the ticket so implementation is straightforward.",
                "Thank you! I'll annotate the Figma frames with the precise specs so the tickets are easy to implement.",
                "Appreciated! I'll prepare a clear spec document to attach to the tickets so developers can work independently.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Thanks for understanding. I'll verify the design in the next staging release.",
                  label: "💡 Wrap-up",
                  translationJa: "理解していただきありがとうございます。次のステージングリリースでデザインを検証しますね。",
                  aiReplies: [
                    "Great! I'll review the staging build carefully and provide detailed feedback on any remaining issues.",
                    "Perfect. A proper design review on staging will catch any implementation gaps early.",
                    "Sounds good! I'll use my design checklist to verify every element in the next staging review.",
                  ],
                ),
              ],
            ),
            ChatReplyOption(
              text: "I can show you how to commit Git code. Wouldn't it be faster if UX designers edited CSS directly?",
              label: "⚠️ Persist (Push Role)",
              translationJa: "Git操作を教えますよ。UXデザイナーが直接CSSを編集した方が早いのではありませんか？",
              aiReplies: [
                "Designers editing source repositories directly introduces risk of broken builds and inconsistent styling tokens. Devs should apply code changes.",
                "Even for CSS, having non-developers commit to the main codebase creates maintenance overhead. Please have frontend devs handle PRs.",
                "I must keep my focus on design architecture and Figma assets. Developers are responsible for code quality and testing.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "That makes sense. Design token integrity and PR code quality belong with developers.",
                  label: "💡 Respect Workflow",
                  translationJa: "理にかなっていますね。デザインキーの整合性とPRの品質管理は開発者が行うべきです。",
                  aiReplies: [
                    "Thank you! Keeping code maintenance with developers ensures our design system stays consistent.",
                    "Appreciated! I'll update Figma with the token definitions so your frontend team can integrate easily.",
                    "Great! Clear roles ensure both design and code quality remain high.",
                  ],
                ),
              ],
            ),
          ],
        ),
        ChatReplyOption(
          text: "The current implementation looks fine to me. Users won't notice those small differences.",
          label: "❌ Dismissive",
          translationJa: "今の実装で問題ないと思います。ユーザーはその小さな違いに気づきません。",
          aiReplies: [
            "Design consistency directly affects user trust and brand perception. These details matter more than they appear.",
            "Actually, design discrepancies — even small ones — can reduce user confidence and make the interface feel unpolished.",
            "Users do notice these things, often subconsciously. Consistency in spacing and states is key to a professional product.",
          ],
          nextOptions: [
            ChatReplyOption(
              text: "I understand. Consistency is key for user trust. Let's fix these details to match your design.",
              label: "💡 Reconsider",
              translationJa: "理解しました。一貫性はユーザーの信頼を得るための鍵です。デザインに合わせるために、細部を修正しましょう。",
              aiReplies: [
                "Thank you! I'll prepare an annotated Figma spec to guide the developers on exactly what needs to change.",
                "Appreciated! Small design details add up to a premium user experience. I'll have the specs ready by EOD.",
                "Great. I'll organize the design issues by priority so the most impactful fixes can be addressed first.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Thank you. A polished UI really improves the user experience. I'll help double-check.",
                  label: "💡 Wrap-up",
                  translationJa: "ありがとうございます。磨き抜かれたUIは、ユーザー体験を本当に向上させます。ダブルチェックをお手伝いします。",
                  aiReplies: [
                    "Wonderful! I'll go through each screen systematically and share a final review report.",
                    "Thank you! A polished final product is what we both want. I'll prioritize the review.",
                    "Great collaboration! Let's schedule a joint design review once the fixes are implemented.",
                  ],
                ),
              ],
            ),
            ChatReplyOption(
              text: "Sorry. I underestimated the importance of the design specs. Let's plan to correct these issues.",
              label: "💡 Corrected",
              translationJa: "すみません。デザイン仕様の重要性を過小評価していました。これらの問題の修正を計画しましょう。",
              aiReplies: [
                "No worries! I'll prepare a prioritized list of issues with Figma references so we can address them systematically.",
                "Appreciated! I'll export a clear spec document today so the development team has everything they need.",
                "Thank you for reconsidering! I'll have the design correction plan ready by tomorrow morning.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Perfect. Let's make sure we hit the Figma design standards for the checkout page.",
                  label: "💡 Wrap-up",
                  translationJa: "完璧です。チェックアウトページでFigmaのデザイン基準を確実に満たすようにしましょう。",
                  aiReplies: [
                    "Absolutely! I'll verify every element of the checkout page against the Figma specs after the fixes.",
                    "Great! I'll do a thorough Figma-to-implementation comparison and share a checklist with the team.",
                    "Looking forward to getting this right. A polished checkout experience directly impacts conversion rates.",
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    RoleplayScenario(
      id: 'ux_user_flow',
      personaId: 'ux',
      title: 'User Flow & Wireframe Discussion',
      description: 'Discussing new user onboarding flow wireframes and technical constraints with Sophie.',
      initialAiGreeting:
          "I've completed the wireframes for the new user onboarding flow. It has 5 steps: welcome screen, profile setup, preference selection, tutorial walkthrough, and dashboard landing. Are there any technical constraints I should know about?",
      initialOptions: [
        ChatReplyOption(
          text: "The flow looks clean! One technical consideration: steps 2 and 3 require API calls. Can we add a progress indicator and handle offline gracefully?",
          label: "💡 Recommended",
          translationJa: "フローがすっきりしていますね！技術的な考慮点として、ステップ2と3はAPI呼び出しが必要です。進捗インジケーターとオフライン時のハンドリングを追加できますか？",
          aiReplies: [
            "Great point! I'll design a step progress indicator and an offline state screen for steps 2 and 3 right away.",
            "Absolutely! I'll update the wireframes to include loading states, progress indicators, and offline error screens.",
            "Good catch! I'll add skeleton loading frames and an offline fallback screen to the wireframe set today.",
          ],
          nextOptions: [
            ChatReplyOption(
              text: "Good idea! I'll work with the developers to implement progressive loading. Could you provide the skeleton screen designs for each step?",
              label: "💡 Constructive",
              translationJa: "いい考えですね！開発者とプログレッシブローディングを実装します。各ステップのスケルトンスクリーンのデザインを提供いただけますか？",
              aiReplies: [
                "Of course! I'll design skeleton screens for each of the 5 steps and add them to the Figma file by EOD.",
                "Sure! I'll create the skeleton screen designs and share them via Figma with the developers' handoff notes.",
                "Absolutely! Skeleton screens will improve the perceived performance significantly. I'll have them ready tomorrow.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Thank you, Sophie! I'll create the implementation tickets with your wireframes attached and schedule the development for next sprint.",
                  label: "💡 Wrap-up",
                  translationJa: "ありがとうございます、Sophie！ワイヤーフレームを添付した実装チケットを作成し、次スプリントに開発をスケジュールします。",
                  aiReplies: [
                    "Thank you! I'll finalize the wireframes today so they're ready to attach to the tickets.",
                    "Sounds great! I'll also provide interaction notes so developers understand the flow transitions.",
                    "Perfect! I'll be available for any design questions during the implementation sprint.",
                  ],
                ),
                ChatReplyOption(
                  text: "Let's plan a usability test with 3-5 internal users once the first prototype is ready.",
                  label: "💡 UX Best Practice",
                  translationJa: "最初のプロトタイプが完成したら、3〜5名の社内ユーザーでユーザビリティテストを計画しましょう。",
                  aiReplies: [
                    "Excellent idea! I'll prepare a usability test script and recruit internal testers right away.",
                    "Love it! Early usability testing will save us from costly redesigns later. I'll get the test plan ready.",
                    "Great UX practice! I'll set up the prototype for testing and prepare the research questions.",
                  ],
                ),
              ],
            ),
            ChatReplyOption(
              text: "Should we also consider A/B testing the tutorial step? We could measure completion rates with and without it.",
              label: "💡 Data-Driven",
              translationJa: "チュートリアルステップのA/Bテストも検討すべきでしょうか？有無での完了率を計測できます。",
              aiReplies: [
                "Great idea! I'll design two variants of the onboarding flow — one with and one without the tutorial — for A/B testing.",
                "Love the data-driven approach! I'll prepare both tutorial and no-tutorial variants in Figma for the A/B test.",
                "Absolutely! A/B testing will give us real data to make an informed design decision. I'll design both variants.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Thank you, Sophie! I'll create the implementation tickets with your wireframes attached and schedule the development for next sprint.",
                  label: "💡 Wrap-up",
                  translationJa: "ありがとうございます、Sophie！ワイヤーフレームを添付した実装チケットを作成し、次スプリントに開発をスケジュールします。",
                  aiReplies: [
                    "Wonderful! I'll have both A/B variants ready to attach to the tickets by tomorrow.",
                    "Sounds great. I'll make sure the variant specifications are clearly documented for the developers.",
                    "Thank you! I'll include the A/B test success metrics in the Figma handoff notes.",
                  ],
                ),
              ],
            ),
          ],
        ),
        ChatReplyOption(
          text: "Five steps is too many. Users will drop off. Can you code a simpler 2-step version yourself?",
          label: "⚠️ UX Trigger",
          translationJa: "5ステップは多すぎます。ユーザーが離脱します。Sophie自身でシンプルな2ステップ版をコーディングできますか？",
          aiReplies: [
            "Coding isn't my role as a UX Designer. I create wireframes and prototypes. Developers need to build the implementation.",
            "I design, I don't code. However, I'm happy to redesign the flow to reduce steps — the developers will build it.",
            "Building code is outside my scope, but I absolutely can redesign the flow to be simpler and more efficient.",
          ],
          nextOptions: [
            ChatReplyOption(
              text: "Pardon me, Sophie. I didn't mean to suggest you should code. Let's discuss a simplified wireframe design instead.",
              label: "💡 Apology",
              translationJa: "失礼しました、Sophie。あなたにコーディングさせようという意図ではありませんでした。代わりに、簡略化したワイヤーフレームのデザインについて議論しましょう。",
              aiReplies: [
                "No worries! I'm happy to explore a condensed flow. Let's review which steps we can merge or simplify.",
                "Thank you! I'll sketch out a leaner 3-step variation we can evaluate together right now.",
                "Appreciated! I'll look at combining steps 2 and 3 to reduce friction while maintaining key functionality.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Yes, let's look at how we can condense steps 2, 3, and 4 into a simpler flow together.",
                  label: "💡 Wrap-up",
                  translationJa: "はい、ステップ2、3、4をよりシンプルなフローに凝縮する方法を一緒に考えましょう。",
                  aiReplies: [
                    "Let's do it! I'll share my screen and we can review the condensed flow wireframes together.",
                    "Sounds great! I'll start with a draft that merges preference selection into the profile setup step.",
                    "Perfect. I'll sketch the condensed flow and share it in Figma within the next 30 minutes.",
                  ],
                ),
              ],
            ),
            ChatReplyOption(
              text: "My apologies. I'll task a developer with creating the prototype once we agree on the final flow. Let's review the steps.",
              label: "💡 Corrected",
              translationJa: "申し訳ありません。最終的なフローに合意できたら、開発者にプロトタイプ作成を依頼します。各ステップをレビューしましょう。",
              aiReplies: [
                "Thank you! Let's go through each step and identify which ones we can simplify or combine.",
                "Appreciated! I'll bring up the wireframes now and we can walk through the flow step by step.",
                "Great! Let's evaluate the user journey critically and see where we can reduce unnecessary friction.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Great. Let's see if we can merge preference selection and profile setup.",
                  label: "💡 Wrap-up",
                  translationJa: "素晴らしいです。プロファイル設定と好みの選択をマージできるか確認しましょう。",
                  aiReplies: [
                    "Let's explore it! Combining them could reduce the step count while keeping the personalization benefit.",
                    "Great suggestion! I'll prototype a merged step and see how it flows in user testing.",
                    "Smart idea. Merging preference selection into profile setup could save a full screen and reduce drop-off.",
                  ],
                ),
              ],
            ),
            ChatReplyOption(
              text: "Wouldn't coding an HTML prototype communicate your UX vision more accurately than wireframes?",
              label: "⚠️ Persist (Push Role)",
              translationJa: "ワイヤーフレームよりHTMLプロトタイプをコードで描いた方がUXのイメージが正確に伝わりませんか？",
              aiReplies: [
                "Interactive design prototypes in Figma communicate UI behavior and UX nuance far better than draft code. Developers should write production HTML/CSS.",
                "Figma components already capture motion, layout, and states accurately. Coding prototypes dilutes design time without speeding up dev delivery.",
                "I use high-fidelity design prototypes to validate user flows. Production coding stays in the dev domain to ensure software architecture standard.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Understood. Figma interactive prototypes convey enough nuance. Let's work on the design wireframe.",
                  label: "💡 Trust Design Tools",
                  translationJa: "了解です。Figmaのインタラクティブプロトタイプで十分伝わるのですね。ワイヤーフレームの調整を進めましょう。",
                  aiReplies: [
                    "Thank you for trusting the design process! I'll build an interactive Figma prototype to demonstrate the 2-step flow.",
                    "Appreciated! High-fidelity prototypes will let us user-test the condensed flow before writing a single line of code.",
                    "Great! I'll prepare the Figma prototype link so the whole team can experience the new 2-step flow.",
                  ],
                ),
              ],
            ),
          ],
        ),
        ChatReplyOption(
          text: "Let's skip the tutorial walkthrough entirely. Nobody reads tutorials anyway.",
          label: "❌ Dismissive",
          translationJa: "チュートリアルウォークスルーは完全にスキップしましょう。どうせ誰も読みません。",
          aiReplies: [
            "Research actually shows that well-designed onboarding tutorials significantly improve long-term user retention.",
            "Skipping the tutorial entirely could hurt first-time user success rates. Good onboarding reduces early churn.",
            "Tutorial completion rates depend heavily on the design. A well-crafted interactive tour adds real value for new users.",
          ],
          nextOptions: [
            ChatReplyOption(
              text: "You're right. Let's make it optional or skippable so we don't annoy users who don't need it.",
              label: "💡 Reconsider",
              translationJa: "そうですね。不要なユーザーの邪魔にならないよう、オプションまたはスキップ可能にしましょう。",
              aiReplies: [
                "Perfect compromise! I'll add a prominent 'Skip' button and make the tutorial dismissible for returning users.",
                "Great idea! I'll redesign it so it's skippable with a clear CTA, balancing discoverability for new users.",
                "Excellent! I'll design both the tutorial and a skip option so users are in control of their onboarding.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Good suggestion. Adding a 'Skip' button will satisfy both user groups. I'll update the design.",
                  label: "💡 Wrap-up",
                  translationJa: "良い提案です。「スキップ」ボタンを追加すれば、両方のユーザーグループが満足できます。デザインを更新しますね。",
                  aiReplies: [
                    "I'll update the Figma wireframes with the skip option and share them for review by EOD.",
                    "Sounds great! I'll also add analytics tracking so we can measure how many users skip vs. complete the tutorial.",
                    "Perfect! The updated design will be ready for developer handoff tomorrow.",
                  ],
                ),
              ],
            ),
            ChatReplyOption(
              text: "Let's try to make the tutorial highly interactive and brief rather than skipping it entirely.",
              label: "💡 Modify",
              translationJa: "完全にスキップするのではなく、チュートリアルを非常にインタラクティブかつ簡潔にするように努めましょう。",
              aiReplies: [
                "Love that approach! I'll redesign it as a 3-step interactive walkthrough with progress dots and clear skip options.",
                "Great idea! An engaging, brief interactive tour will be far more effective than long static text screens.",
                "Absolutely! I'll create a prototype for an interactive micro-tutorial that takes less than 60 seconds to complete.",
              ],
              nextOptions: [
                ChatReplyOption(
                  text: "Excellent idea. An interactive tour is much more engaging than text screens.",
                  label: "💡 Wrap-up",
                  translationJa: "素晴らしいアイデアです。テキスト画面よりも、インタラクティブなツアーの方がはるかに魅力的です。",
                  aiReplies: [
                    "I'll have the interactive tour prototype ready in Figma for you to review tomorrow!",
                    "Great! An interactive prototype will also help us do usability testing before the dev build.",
                    "Wonderful! I'll share the prototype link once it's ready so we can gather early feedback.",
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ];

  static RoleplayScenario getInitialScenarioFor(String personaId) {
    return scenarios.firstWhere(
      (s) => s.personaId == personaId,
      orElse: () => scenarios.first,
    );
  }
}
