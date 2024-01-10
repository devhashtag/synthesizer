local function test(...)
    for i,v in ipairs(...) do
        print(i)
        print(v)
    end
end

test(1)
test(1,2,3)
print('done')
