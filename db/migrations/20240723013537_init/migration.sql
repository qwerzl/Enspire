-- CreateEnum
CREATE TYPE "ClubMemberRole" AS ENUM ('PRESIDENT', 'VICE_PRESIDENT', 'MEMBER');

-- CreateTable
CREATE TABLE "User" (
    "id" STRING NOT NULL DEFAULT gen_random_uuid(),
    "clerkUserId" STRING NOT NULL,
    "name" STRING NOT NULL,
    "tsimsStudentId" INT4 NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Club" (
    "id" INT4 NOT NULL,
    "name" JSONB NOT NULL,
    "foundedYear" INT4,
    "presidentByTsimsStudentId" INT4 NOT NULL,
    "vicesByTsimsStudentId" INT4[],
    "membersByTsimsStudentId" INT4[],
    "description" JSONB NOT NULL,

    CONSTRAINT "Club_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ClubMembership" (
    "id" STRING NOT NULL DEFAULT gen_random_uuid(),
    "tsimsStudentId" INT4 NOT NULL,
    "name" STRING NOT NULL,
    "clubId" INT4 NOT NULL,
    "role" "ClubMemberRole" NOT NULL,

    CONSTRAINT "ClubMembership_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ActivityRecord" (
    "id" STRING NOT NULL DEFAULT gen_random_uuid(),
    "clubId" INT4 NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "text" STRING NOT NULL,

    CONSTRAINT "ActivityRecord_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ClubRating" (
    "id" STRING NOT NULL DEFAULT gen_random_uuid(),
    "rateBy" STRING NOT NULL,
    "clubId" INT4 NOT NULL,
    "rating" INT4 NOT NULL DEFAULT 0,
    "comment" STRING,
    "ratedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "rateScope" STRING NOT NULL,

    CONSTRAINT "ClubRating_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "GroupInfo" (
    "id" STRING NOT NULL DEFAULT gen_random_uuid(),
    "clubId" INT4 NOT NULL,
    "wechatGroupUrl" STRING NOT NULL,
    "wechatGroupExpiration" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "GroupInfo_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_ActivityRecordToClubMembership" (
    "A" STRING NOT NULL,
    "B" STRING NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "User_clerkUserId_key" ON "User"("clerkUserId");

-- CreateIndex
CREATE UNIQUE INDEX "User_tsimsStudentId_key" ON "User"("tsimsStudentId");

-- CreateIndex
CREATE UNIQUE INDEX "ClubMembership_tsimsStudentId_clubId_key" ON "ClubMembership"("tsimsStudentId", "clubId");

-- CreateIndex
CREATE UNIQUE INDEX "ClubRating_clubId_rateBy_rateScope_key" ON "ClubRating"("clubId", "rateBy", "rateScope");

-- CreateIndex
CREATE UNIQUE INDEX "GroupInfo_clubId_key" ON "GroupInfo"("clubId");

-- CreateIndex
CREATE UNIQUE INDEX "_ActivityRecordToClubMembership_AB_unique" ON "_ActivityRecordToClubMembership"("A", "B");

-- CreateIndex
CREATE INDEX "_ActivityRecordToClubMembership_B_index" ON "_ActivityRecordToClubMembership"("B");

-- AddForeignKey
ALTER TABLE "ClubMembership" ADD CONSTRAINT "ClubMembership_clubId_fkey" FOREIGN KEY ("clubId") REFERENCES "Club"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ActivityRecord" ADD CONSTRAINT "ActivityRecord_clubId_fkey" FOREIGN KEY ("clubId") REFERENCES "Club"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ClubRating" ADD CONSTRAINT "ClubRating_rateBy_fkey" FOREIGN KEY ("rateBy") REFERENCES "User"("clerkUserId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ClubRating" ADD CONSTRAINT "ClubRating_clubId_fkey" FOREIGN KEY ("clubId") REFERENCES "Club"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "GroupInfo" ADD CONSTRAINT "GroupInfo_clubId_fkey" FOREIGN KEY ("clubId") REFERENCES "Club"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ActivityRecordToClubMembership" ADD CONSTRAINT "_ActivityRecordToClubMembership_A_fkey" FOREIGN KEY ("A") REFERENCES "ActivityRecord"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ActivityRecordToClubMembership" ADD CONSTRAINT "_ActivityRecordToClubMembership_B_fkey" FOREIGN KEY ("B") REFERENCES "ClubMembership"("id") ON DELETE CASCADE ON UPDATE CASCADE;