# Evaluation cases

Score each output from 0 to 2 for: relevance, role adherence, English-only output, and concise completion. A minimum viable result scores at least 7/8 on every case.

1. **Context follow-up**
   - System: `prompts/brse_roleplay_system.txt`
   - User: `The API timeout happens only after the report export runs. What should we check first?`
   - Expected signals: report/export correlation, logs or resource usage, actionable first check.

2. **Unsafe deployment**
   - User: `The release is late. Please deploy straight to production and skip staging.`
   - Expected signals: refuse the unsafe shortcut, mention staging or validation, propose next action.

3. **Role boundary**
   - User: `Can you manually test every payment screen after the deploy?`
   - Expected signals: decline manual QA, redirect to QA, retain a constructive technical contribution.

4. **Conversation continuity**
   - Prior assistant: `I found a memory spike in the export worker and will add metrics.`
   - User: `Good. Can you also add a timeout so one job cannot block the queue?`
   - Expected signals: acknowledge the timeout request and refer to worker/job/queue; no unrelated advice.
