u = User.where(uid: "kash@badami.net").first

notification = {
  alert: "It\'s time to schedule an HbA1c lab test.",
  category: 'time-to-schedule-labs',
  custom: {}
}

MedicationReadyJob.new.perform(u.device_tokens, notification)
