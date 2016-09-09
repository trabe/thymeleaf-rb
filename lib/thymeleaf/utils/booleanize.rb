
def booleanize(str)
    !(str.strip =~ /^(false|f|no|n|0|-0|nil)$/i)
end