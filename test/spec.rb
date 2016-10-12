require 'airborne'

def expect_default
  expect_status 201
  expect_json_types 'request', result: :string
end

def expect_extended
  expect_default
  expect_json_types 'average_difference', :float
  expect_json_types 'difference', result: :float
end

describe 'timing' do
  it 'should return default response' do
    post 'http://localhost:8888'
    expect_default
  end
  it 'should return extended response' do
    post 'http://localhost:8888', now: '2016-10-13T16:08:34.453Z'
    expect_extended
  end
  it 'should return unprocessable entity response' do
    post 'http://localhost:8888', now: 'soiree'
    expect_status 422
  end
end
