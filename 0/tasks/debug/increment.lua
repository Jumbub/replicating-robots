local task = {}

function task:prepare(state)
  return { start = state }
end

function task:complete(state)
  return state.count == self.args.to
end

function task:perform(state, push) end

return task
