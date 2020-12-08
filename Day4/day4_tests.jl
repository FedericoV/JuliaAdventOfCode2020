include("day4_solution.jl")
using Test

# byr valid:   2002
# byr invalid: 2003
@test validate_birth_year("2002")
@test !validate_birth_year("2003") 

# hgt valid:   60in
# hgt valid:   190cm
# hgt invalid: 190in
# hgt invalid: 190
@test validate_height("60in")
@test validate_height("190cm")
@test !validate_height("190in")
@test !validate_height("190")


# hcl valid:   #123abc
# hcl invalid: #123abz
# hcl invalid: 123abc
@test validate_hair_color("#123abc")
@test !validate_hair_color("#123abz")
@test !validate_hair_color("123abc")

# ecl valid:   brn
# ecl invalid: wat
@test validate_eye_color("brn")
@test !validate_eye_color("wat")

# pid valid:   000000001
# pid invalid: 0123456789
@test validate_pid("000000001")
@test !validate_pid("0123456789")

bad_pwd_1 = "eyr:1972 cid:100
hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926"

bad_pwd_2 = "iyr:2019
hcl:#602927 eyr:1967 hgt:170cm
ecl:grn pid:012533040 byr:1946"

bad_pwd_3 = "hcl:dab227 iyr:2012
ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277"

bad_pwd_4 = "hgt:59cm ecl:zzz
eyr:2038 hcl:74454a iyr:2023
pid:3556412378 byr:2007"

@test !is_valid_passport(bad_pwd_1)
@test !is_valid_passport(bad_pwd_2)
@test !is_valid_passport(bad_pwd_3)
@test !is_valid_passport(bad_pwd_4)

good_pwd_1 = "pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
hcl:#623a2f"

good_pwd_2 = "eyr:2029 ecl:blu cid:129 byr:1989
iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm"

good_pwd_3 = "hcl:#888785
hgt:164cm byr:2001 iyr:2015 cid:88
pid:545766238 ecl:hzl
eyr:2022"

good_pwd_4 = "iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719"

@test is_valid_passport(good_pwd_1)
@test is_valid_passport(good_pwd_2)
@test is_valid_passport(good_pwd_3)
@test is_valid_passport(good_pwd_4)