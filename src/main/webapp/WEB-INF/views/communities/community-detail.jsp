<div id="page-community-detail" class="page-content d-none">
    <div class="mb-4">
        <button class="btn btn-outline-primary" onclick="showPage('communities')">
            <i class="fas fa-arrow-left me-2"></i>Back to Communities
        </button>
    </div>

    <div class="bg-white rounded-xl overflow-hidden mb-6" id="communityDetailContent">
    </div>

    <div class="row">
        <div class="col-md-6">
            <div class="bg-white rounded-xl p-4 shadow-sm">
                <div class="d-flex justify-content-between mb-4">
                    <h3>Members</h3>
                    <button class="btn btn-sm btn-primary" onclick="showPage('community-members')">
                        Manage Members
                    </button>
                </div>
                <div id="communityMembersPreview">
                </div>
            </div>
        </div>

        <div class="col-md-6">
            <div class="bg-white rounded-xl p-4 shadow-sm">
                <div class="d-flex justify-content-between mb-4">
                    <h3>Events</h3>
                    <button class="btn btn-sm btn-primary" onclick="showPage('create-event')">
                        Create Event
                    </button>
                </div>
                <div id="communityEventsPreview">
                </div>
            </div>
        </div>
    </div>
</div>
