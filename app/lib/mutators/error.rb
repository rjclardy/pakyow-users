Pakyow::App.mutators :error do
  mutator :present do |view, errors|
    view.with do
      attrs.class.ensure(:active)
      attrs.class.deny(:hidden)

      prop(:message).repeat(errors) do |context, message|
        context.text = message
      end
    end
  end
end
