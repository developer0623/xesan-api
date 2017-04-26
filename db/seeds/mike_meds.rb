u = User.where(uid: 'mike@gmail.com').first

m = Medication.create({
  name: "Clonazepam",
  dose: "1",
  frequency: "as needed",
  strength: "0.5mg",
  refills_remaining: nil,
  discard_date: nil,
  reason_for_taking: nil,
  form: "Tablets",
  count: 30,
  route: "By mouth",
  category: "Rx Medication",
  description: nil,
  instructions: "as needed",
  ndc: "00603-2948-32",
  prescriber_id: 1831152842,
  pharmacy_id: 1376576629
})

RefillInfo.create({
  medication_id: m.id,
  rx_number: "4081298",
  rx_fill_date: "2015-10-26",
  refill_num: 2,
  refill_total: 3,
  current_med_count: 0,
  days_supply: 30,
  discard_date: "2016-10-24",
  refills_expiration: "2015-12-13",
  created_at: Time.now,
  active_refill: true
})

Reminder.create({
  medication_id: m.id,
  user_id: u.id,
  guid: "a799b5ad-3864-33b2-85e3-d172ba8d43b9",
  sunday: true,
  monday: true,
  tuesday: true,
  wednesday: true,
  thursday: true,
  friday: true,
  saturday: true,
  hour: 9,
  minute: 0,
  start_date: Time.now - 1.hour,
  deleted: false
})

m.user_id = u.id
m.save

notification = {
  alert: "Your Medication is Ready",
  category: 'med-ready',
  custom: {
    medId: m.id
  }
}

MedicationReadyJob.new.perform(u.device_tokens, notification)
