require "./spec_helper"

module Liquid
  describe "Match Regex" do
    it "should match vars" do
      ok = ["mavar", "ma_var", "mavar2", "m646_dfd54", "_tagazok"]
      err = ["2var", "Unexpected-", "not-me", "rage$"]
      ok.each &.match(/^#{VAR}$/).should_not be_nil
      err.each &.match(/^#{VAR}$/).should be_nil
    end

    it "should match String, int and float" do
      ok = ["\"\"", "\"not empty string\"", "12", "-12", "15.68", "-20.36"]
      err = ["\"\"\"", "\"doo bi \" YOLO \" doop\"", "--545", "54.54.5", "115-"]
      ok.each &.match(/^#{TYPE}$/).should_not be_nil
      err.each &.match(/^#{TYPE}$/).should be_nil
    end

    it "should match a type or a var" do
      ok = ["\"\"", "\"not empty string\"", "12", "-12", "15.68", "-20.36", "ma_var"]
      err = ["\"\"\"", "\"doo bi \" YOLO \" doop\"", "--545", "54.54.5", "115-", "not-me", "-troll"]
      ok.each &.match(/^#{TYPE_OR_VAR}$/).should_not be_nil
      err.each &.match(/^#{TYPE_OR_VAR}$/).should be_nil
    end

    it "should match a comparison" do
      ok = ["a == b", "sdf != fds", "dd < 12", "true > false", "hh==hh", "12 <= var"]
      err = ["a = b", "dfs ! fff", "ddd=ddd", "12>"]
      ok.each &.match(/^#{CMP}$/).should_not be_nil
      err.each &.match(/^#{CMP}$/).should be_nil
    end

    it "should match filters" do
      ok = ["a | b", "a | b | v", "-12 | abs", "\"toto\" | abs"]
      err = ["a ||", "dfs |", "|ddd=ddd", "1|2", "dd | 12"]
      ok.each &.match(/^#{FILTERED}$/).should_not be_nil
      err.each &.match(/^#{FILTERED}$/).should be_nil
    end

    it "should match filters with multiple arguments" do
      "filtered | filter: arg1, arg2".match(/^#{GFILTERED}$/).should_not be_nil
    end

    it "should match a string" do
      "\"content\"".match(GSTRING).should_not be_nil
    end
  end
end
