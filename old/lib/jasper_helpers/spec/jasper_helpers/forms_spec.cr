require "../spec_helper"

describe JasperHelpers::Forms do
  describe "#text_field" do
    it "main param works with string" do
      expected = "<input type=\"text\" name=\"my-great-text-input\" id=\"my-great-text-input\"/>"
      text_field("my-great-text-input").should eq(expected)
    end

    it "main param works with symbol" do
      text_field(:name).should eq("<input type=\"text\" name=\"name\" id=\"name\"/>")
    end

    it "input type with symbol works" do
      text_field(:name, type: :password).should eq("<input type=\"password\" name=\"name\" id=\"name\"/>")
    end

    it "style value works" do
      text_field(:name, style: "color: white;").should eq("<input type=\"text\" name=\"name\" id=\"name\" style=\"color: white;\"/>")
    end
  end

  describe "#file_field" do
    it "main param works with string" do
      expected = "<input type=\"file\" name=\"my-great-file-input\" id=\"my-great-file-input\"/>"
      file_field("my-great-file-input").should eq(expected)
    end

    it "main param works with symbol" do
      file_field(:name).should eq("<input type=\"file\" name=\"name\" id=\"name\"/>")
    end

    it "style value works" do
      file_field(:name, style: "color: white;").should eq("<input type=\"file\" name=\"name\" id=\"name\" style=\"color: white;\"/>")
    end
  end

  describe "#wrapper_field" do
    it "creates with nil" do
      wrapper_field(nil).should eq("")
    end

    it "creates with string" do
      wrapper_field("<br>").should eq("<br>")
    end

    it "creates with element" do
      expected = "<input type=\"text\" name=\"my-great-text-input\" id=\"my-great-text-input\"/>"

      wrapper_field(text_field("my-great-text-input")).should eq(expected)
    end

    it "creates with string and element" do
      expected = "<br><input type=\"text\" name=\"my-great-text-input\" id=\"my-great-text-input\"/>"

      wrapper_field(
        "<br>",
        text_field("my-great-text-input")
      ).should eq(expected)
    end
  end

  describe "#label" do
    it "creates with string" do
      label("name", "My Label").should eq("<label for=\"name\" id=\"name_label\">My Label</label>")
    end

    it "creates with symbol" do
      label(:name, "My Label").should eq("<label for=\"name\" id=\"name_label\">My Label</label>")
    end

    it "creates with string and options" do
      label(:name, "My Label", class: "label").should eq("<label for=\"name\" id=\"name_label\" class=\"label\">My Label</label>")
    end

    it "creates with content" do
      expected = "<label for=\"name\" id=\"name_label\"><input type=\"checkbox\" name=\"allowed\" id=\"allowed\" value=\"1\"/><input type=\"hidden\" name=\"allowed\" id=\"allowed_default\" value=\"0\"/></label>"
      label(:name) do
        check_box(:allowed)
      end.should eq(expected)
    end

    it "creates with wrapper_field" do
      expected = "<label for=\"name\" id=\"name_label\">name<input type=\"checkbox\" name=\"allowed\" id=\"allowed\" value=\"1\"/><input type=\"hidden\" name=\"allowed\" id=\"allowed_default\" value=\"0\"/></label>"
      label(:name) do
        wrapper_field(
          "name",
          check_box(:allowed)
        )
      end.should eq(expected)
    end
  end

  describe "#form" do
    it "allows for nested input fields" do
      result = form(id: "myForm") do
        text_field(:name)
      end
      expected = "<form id=\"myForm\" method=\"post\"><input type=\"text\" name=\"name\" id=\"name\"/></form>"

      result.should eq(expected)
    end

    it "sets up form for multipart" do
      result = form(method: :post, action: "/test/1", id: "myForm", multipart: true) do
        text_field(:name)
      end
      expected = %(<form action="/test/1" id="myForm" multipart="true" method="post" enctype="multipart/form-data"><input type="text" name="name" id="name"/></form>)

      result.should eq(expected)
    end
  end

  describe "#hidden_field" do
    it "creates a hidden field" do
      hidden_field(:token).should eq("<input type=\"hidden\" name=\"token\" id=\"token\"/>")
    end
  end

  describe "#select_field" do
    it "creates a select_field with two dimension arrays" do
      select_field(:age, [[1, "A"], [2, "B"]]).should eq("<select class=\"age\" id=\"age\" name=\"age\"><option value=\"1\">A</option><option value=\"2\">B</option></select>")
    end

    it "creates a select_field with array of hashes" do
      select_field(:age, [{:"1" => "A"}, {:"2" => "B"}]).should eq("<select class=\"age\" id=\"age\" name=\"age\"><option value=\"1\">A</option><option value=\"2\">B</option></select>")
    end

    it "creates a select_field with a hash" do
      select_field(:age, {:"1" => "A", :"2" => "B"}).should eq("<select class=\"age\" id=\"age\" name=\"age\"><option value=\"1\">A</option><option value=\"2\">B</option></select>")
    end

    it "creates a select_field with a hash and id" do
      expected = "<select id=\"age_of_thing\" name=\"age\"><option value=\"1\">A</option><option value=\"2\">B</option></select>"
      select_field(:age, {:"1" => "A", :"2" => "B"}, id: "age_of_thing").should eq(expected)
    end

    it "creates a select_field with a named tuple" do
      select_field(:age, {"1": "A", "2": "B"}).should eq("<select class=\"age\" id=\"age\" name=\"age\"><option value=\"1\">A</option><option value=\"2\">B</option></select>")
    end

    it "creates a select_field with a namedtuple and id" do
      expected = "<select id=\"age_of_thing\" name=\"age\"><option value=\"1\">A</option><option value=\"2\">B</option></select>"
      select_field(:age, {"1": "A", "2": "B"}, id: "age_of_thing").should eq(expected)
    end

    it "creates a select_field with B selected (String scalar)" do
      expected = "<select name=\"age\"><option value=\"1\">A</option><option value=\"2\" selected=\"selected\">B</option></select>"
      select_field(:age, {"1": "A", "2": "B"}, selected: "2").should eq(expected)
    end

    it "creates a select_field with B selected (Int32 scalar)" do
      expected = "<select name=\"age\"><option value=\"1\">A</option><option value=\"2\" selected=\"selected\">B</option></select>"
      select_field(:age, {"1": "A", "2": "B"}, selected: 2).should eq(expected)
    end

    it "creates a select_field with B and C selected (String array)" do
      expected = "<select name=\"age\"><option value=\"1\">A</option><option value=\"2\" selected=\"selected\">B</option><option value=\"3\" selected=\"selected\">C</option></select>"
      select_field(:age, {"1": "A", "2": "B", "3": "C"}, selected: ["2", "3"]).should eq(expected)
    end

    it "creates a select_field with B and C selected (Int32 array)" do
      expected = "<select name=\"age\"><option value=\"1\">A</option><option value=\"2\" selected=\"selected\">B</option><option value=\"3\" selected=\"selected\">C</option></select>"
      select_field(:age, {"1": "A", "2": "B", "3": "C"}, selected: [2, 3]).should eq(expected)
    end

    it "creates a select_field with B and C selected (Int32 | String array)" do
      expected = "<select name=\"age\"><option value=\"1\">A</option><option value=\"2\" selected=\"selected\">B</option><option value=\"3\" selected=\"selected\">C</option></select>"
      select_field(:age, {"1": "A", "2": "B", "3": "C"}, selected: [2, "3"]).should eq(expected)
    end

    it "creates a select_field with single dimension array" do
      select_field(:age, ["A", "B"]).should eq("<select class=\"age\" id=\"age\" name=\"age\"><option value=\"A\">A</option><option value=\"B\">B</option></select>")
    end

    it "creates a select_field with range" do
      select_field(:age, collection: 1..5).should eq("<select class=\"age\" id=\"age\" name=\"age\"><option value=\"1\">1</option><option value=\"2\">2</option><option value=\"3\">3</option><option value=\"4\">4</option><option value=\"5\">5</option></select>")
    end
  end

  describe "#text_area" do
    it "creates a text_area" do
      text_area(:description, "My Great Textarea").should eq("<textarea name=\"description\" id=\"description\">My Great Textarea</textarea>")
    end

    it "allows for rows and cols to be specified" do
      text_area(:description, "My Great Textarea", cols: 5, rows: 10).should eq("<textarea name=\"description\" id=\"description\" cols=\"5\" rows=\"10\">My Great Textarea</textarea>")
    end

    it "allows for size to be specified" do
      text_area(:description, "My Great Textarea", size: "5x10").should eq("<textarea name=\"description\" id=\"description\" cols=\"5\" rows=\"10\">My Great Textarea</textarea>")
    end
  end

  describe "#submit" do
    it "creates a submit with no parameters" do
      submit.should eq("<input type=\"submit\" value=\"Save Changes\" id=\"save_changes\"/>")
    end

    it "creates a submit with no parameters except id" do
      submit(id: :submit_button).should eq("<input type=\"submit\" value=\"Save Changes\" id=\"submit_button\"/>")
    end

    it "creates a submit with value parameter" do
      submit(:create).should eq("<input type=\"submit\" value=\"create\" id=\"create\"/>")
    end

    it "creates a submit with value and id parameters" do
      submit(:create, id: "my-submit-tag").should eq("<input type=\"submit\" value=\"create\" id=\"my-submit-tag\"/>")
    end
  end

  describe "#check_box" do
    it "creates a check_box with yes/no" do
      expected = "<input type=\"checkbox\" name=\"allowed\" id=\"allowed\" value=\"yes\"/><input type=\"hidden\" name=\"allowed\" id=\"allowed_default\" value=\"no\"/>"
      check_box(:allowed, checked_value: "yes", unchecked_value: "no").should eq(expected)
    end

    it "creates a check_box with only value" do
      expected = "<input type=\"checkbox\" name=\"allowed\" id=\"allowed\" value=\"1\"/><input type=\"hidden\" name=\"allowed\" id=\"allowed_default\" value=\"0\"/>"
      check_box(:allowed).should eq(expected)
    end

    it "marks box as checked" do
      expected = "<input type=\"checkbox\" name=\"allowed\" id=\"allowed\" value=\"1\" checked=\"checked\"/><input type=\"hidden\" name=\"allowed\" id=\"allowed_default\" value=\"0\"/>"
      check_box(:allowed, checked: true).should eq(expected)
    end

    it "marks box as not checked" do
      expected = "<input type=\"checkbox\" name=\"allowed\" id=\"allowed\" value=\"1\"/><input type=\"hidden\" name=\"allowed\" id=\"allowed_default\" value=\"0\"/>"
      check_box(:allowed, checked: false).should eq(expected)
    end
  end
end
