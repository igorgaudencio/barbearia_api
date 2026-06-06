Barbeiro.destroy_all

Barbeiro.create!(email: "barbeiro@email.com").tap do |b|
  b.password = "123456"
  b.save!
end

puts "Barbeiro criado: barbeiro@email.com / 123456"
