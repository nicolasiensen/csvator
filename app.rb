require 'sinatra'
require 'slim'
require 'csv'

get '/' do
  slim :index
end

post '/generator' do
  headers "Content-Disposition" => "attachment;filename=#{params['name'] == "" ? "generator" : params['name'].gsub(" ", "_")}.csv", "Content-Type" => "application/octet-stream"
  list1 = CSV.parse(params['list1'][:tempfile].read)[1..-1]
  list2 = CSV.parse(params['list2'][:tempfile].read)[1..-1]
  result = "Nome, Email\n"
  eval("#{params['operation']}(list1, list2)").each do |item|
    result << "#{item[0]}, #{item[1]}\n"
  end
  result
end

def union list1, list2
  list1 | list2
end

def intersection list1, list2
  list1 & list2
end

def subtraction list1, list2
  list1 - list2
end
