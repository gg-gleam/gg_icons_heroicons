import gg_icons_heroicons/micro/c as micro_c
import gg_icons_heroicons/mini/c as mini_c
import gg_icons_heroicons/outline/c as outline_c
import gg_icons_heroicons/solid/c as solid_c
import gleam/string
import gleeunit
import gleeunit/should
import lustre/element

pub fn main() {
  gleeunit.main()
}

pub fn outline_variant_is_stroked_test() {
  let html = element.to_string(outline_c.check_circle([]))

  should.be_true(string.contains(html, "stroke=\"currentColor\""))
  should.be_true(string.contains(html, "fill=\"none\""))
  should.be_true(string.contains(html, "stroke-width=\"1.5\""))
  should.be_true(string.contains(html, "viewBox=\"0 0 24 24\""))
}

pub fn solid_variant_is_solid_test() {
  let html = element.to_string(solid_c.check_circle([]))

  // The solid paint model: a solid fill, no stroke default.
  should.be_true(string.contains(html, "fill=\"currentColor\""))
  should.be_false(string.contains(html, "stroke=\"currentColor\""))
  should.be_true(string.contains(html, "viewBox=\"0 0 24 24\""))
}

pub fn mini_variant_is_20_box_test() {
  let html = element.to_string(mini_c.check_circle([]))

  should.be_true(string.contains(html, "fill=\"currentColor\""))
  should.be_true(string.contains(html, "viewBox=\"0 0 20 20\""))
}

pub fn micro_variant_is_16_box_test() {
  let html = element.to_string(micro_c.check_circle([]))

  should.be_true(string.contains(html, "fill=\"currentColor\""))
  should.be_true(string.contains(html, "viewBox=\"0 0 16 16\""))
}
