RSpec.describe Hanami::Events do
  let(:event) { Hanami::Events.build(:memory) }

  it { expect(event).to be_a(Hanami::Events::Base) }

  describe '#adapter' do
    it { expect(event.adapter).to be_a(Hanami::Events::Adapter::Memory) }
  end

  describe '#broadcast' do
    let(:event_name) { 'user.created' }

    before do
      event.subscribe(event_name) { |payload| payload }
    end

    it 'calls #broadcast on adapter' do
      expect(event.adapter).to receive(:broadcast).with('user.created', user_id: 1)
      event.broadcast('user.created', user_id: 1)
    end
  end

  describe '#subscribed_events' do
    before do
      event.subscribe('user.created') { |payload| payload }
      event.subscribe('user.updated') { |payload| payload }
      event.subscribe('user.deleted') { |payload| payload }
    end

    it 'returns list of all subscribed events' do
      expect(event.subscribed_events).to eq([
        { title: 'user.created' },
        { title: 'user.updated' },
        { title: 'user.deleted' }
      ])
    end
  end

  describe '#subscribe' do
    it 'pushes subscriber to subscribers list' do
      expect {
        event.subscribe('event.name') { |payload| payload }
      }.to change { event.adapter.subscribers.count }.by(1)
    end
  end
end
