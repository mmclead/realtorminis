contact_info = {
  first_name: "Mason",
  last_name: "McLead",
  contact_type: "COMPANY",
  organization_name: "RealtorMinis",
  address_line_1: "2403 Rockefeller Lane",
  address_line_2: "Unit A",
  city: "Redondo Beach",
  state: "CA",
  country_code: "US",
  zip_code: "90278",
  phone_number: "+1.3109621144",
  email: "mason@realtorminis.com"
}

Rails.configuration.domains = {
  admin_contact: contact_info,
  registrant_contact: contact_info,
  tech_contact: contact_info,
}



